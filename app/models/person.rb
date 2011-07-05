class Person
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :finished_flag, :type => Boolean, :default => false
  
  has_and_belongs_to_many :bills
  
  embeds_many :accounts

  accepts_nested_attributes_for :accounts, :allow_destroy => true
  
  def add_credit(bill, amount)
    get_account(bill).add_credit amount
  end
  
  def add_debit(bill, amount)
    get_account(bill).add_debit amount
  end
  
  def balance(bill)
    get_account(bill).balance
  end
  
  def absolute_balance(bill)
    balance(bill).abs
  end
  
  def get_account(bill)
    accounts.each do |account|
      return account if account.bill == bill
    end
    new_account = Account.new(:person => self, :bill => bill, :balance => 0)
    accounts << new_account
    new_account
  end
  
  def has_pending_debit(bill)
    balance(bill) <= 0.01
  end
  
  def has_pending_credit(bill)
    balance(bill) >= 0.01
  end
end
