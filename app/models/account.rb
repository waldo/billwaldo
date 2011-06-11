class Account
   include Mongoid::Document
   include Mongoid::Timestamps  

   field :balance, :type => BigDecimal

   belongs_to :bill
   embedded_in :person
  
    def add_credit(amount)
      self.balance += amount
    end

    def add_debit(amount)
      self.balance -= amount
    end

end