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
          if debitor.has_pending_debit self and creditor.has_pending_credit self
            amt = [creditor.absolute_balance(self), debitor.absolute_balance(self)].min
            self.payments.create!(:amount => amt, :creditor => creditor, :debitor => debitor)
            debitor.add_credit self, amt
            creditor.add_debit self, amt
        end
      end
    end
  end
end
