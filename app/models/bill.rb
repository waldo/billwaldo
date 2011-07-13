class Bill
  include Mongoid::Document
  include Mongoid::Timestamps
  
  attr_protected :uuid
  before_create :gen_uuid
  before_save :update_payments

  field :uuid, :type => String
  field :name, :type => String, :default => "Unnamed"
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
    if !self.people.empty?
      self.payments.clear
      calculate_next_payment
    end
  end

  def calculate_next_payment
    debitor = self.people.min_by do |p| p.balance(self) end
    creditor = self.people.max_by do |p| p.balance(self) end
    if debitor.has_pending_debit self and creditor.has_pending_credit self
      create_payment_and_update_balances debitor, creditor
      calculate_next_payment
    end
  end
  
  def create_payment_and_update_balances(debitor, creditor)
    amount = [creditor.absolute_balance(self), debitor.absolute_balance(self)].min
    self.payments.create!(:amount => amount, :creditor => creditor, :debitor => debitor)
    debitor.add_credit self, amount
    creditor.add_debit self, amount    
  end
end
