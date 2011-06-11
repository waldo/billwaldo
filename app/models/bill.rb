class Bill
  include Mongoid::Document
  include Mongoid::Timestamps
  
  attr_protected :uuid
  before_create :gen_uuid
  before_save :update_payments

  field :uuid, :type => String
  field :name, :type => String
  has_and_belongs_to_many :people
  embeds_many :expenses
  embeds_many :payments

  accepts_nested_attributes_for :people
  accepts_nested_attributes_for :expenses, :allow_destroy => true
  accepts_nested_attributes_for :payments, :allow_destroy => true

  def add_expense(expense)
    self.expenses << expense
    expense.update_balances
  end

  protected
  def gen_uuid
    self.uuid = SecureRandom.hex
  end
  
  def update_payments
    self.payments.clear

    overall_debitors = self.people.reject do |p| p.balance(self) >= 0 end.sort_by do |p| p.balance(self) end
    overall_creditors = self.people.reject do |p| p.balance(self) < 0 end.sort_by do |p| -p.balance(self) end

    overall_debitors.each do |debitor|
      overall_creditors.each do |creditor|
          cred_balance = creditor.balance(self)
          deb_balance = debitor.balance(self)
          if deb_balance <= -0.01 and cred_balance >= 0.01
            amt = cred_balance
            amt = deb_balance.abs if deb_balance.abs < cred_balance

            pay = self.payments.build
            pay.amount = amt
            pay.creditor_id = creditor.id
            pay.debitor_id = debitor.id
            pay.save

            debitor.add_credit self, amt
            creditor.add_debit self, amt
        end
      end
    end
  end
end
