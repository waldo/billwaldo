require 'test_helper'

class BillTest < ActiveSupport::TestCase
  
  setup do
    @adam = Fabricate(:adam)
    @ben = Fabricate(:ben)
    @charlie = Fabricate(:charlie)
    @dan = Fabricate(:dan)
    @ed = Fabricate(:ed)
  end
  
  test "empty bill doesn't die" do
    bill = Fabricate(:bill, :people => [])
    bill.save
    assert bill.payments.length == 0
  end
  
  test "bill payed by one on behalf of himself plus one" do
    bill = Fabricate(:bill, :people => [@adam, @ben])
    bill.add_expense Fabricate.build(:expense, 
      :amount => 2,
      :creditors => [@adam], 
      :debitors => [@adam, @ben]
    )
    bill.save
    assert bill.payments.length == 1    
    assert bill.payments.include? Fabricate.build(:payment,
      :amount => 1,
      :creditor => @adam,
      :debitor => @ben
    )
  end
  
  test "bill payed by one on behalf of two" do
    bill = Fabricate(:bill, :people => [@adam, @ben, @charlie])
    bill.add_expense Fabricate.build(:expense, 
      :amount => 2,
      :creditors => [@adam], 
      :debitors => [@charlie, @ben]
    )
    bill.save
    assert bill.payments.length == 2   
    assert bill.payments.include? Fabricate.build(:payment,
      :amount => 1,
      :creditor => @adam,
      :debitor => @ben
    )
    assert bill.payments.include? Fabricate.build(:payment,
      :amount => 1,
      :creditor => @adam,
      :debitor => @charlie
    )    
  end
  
  test "bill payed by one on behalf of three" do
    bill = Fabricate(:bill, :people => [@adam, @ben, @charlie])
    bill.add_expense Fabricate.build(:expense, 
      :amount => 3,
      :creditors => [@adam], 
      :debitors => [@adam, @ben, @charlie]
    )
    bill.save
    assert bill.payments.length == 2
    assert bill.payments.include? Fabricate.build(:payment, 
      :amount => 1, 
      :creditor => @adam, 
      :debitor => @ben)
    assert bill.payments.include? Fabricate.build(:payment, 
      :amount => 1, 
      :creditor => @adam, 
      :debitor => @charlie)
  end
  
  test "bill payed by two on behalf of three" do
    bill = Fabricate(:bill, :people => [@adam, @ben, @charlie])
    bill.add_expense Fabricate.build(:expense, 
      :amount => 3,
      :creditors => [@adam, @ben], 
      :debitors => [@adam, @ben, @charlie]
    )
    bill.save
    assert bill.payments.length == 2
    assert bill.payments.include? Fabricate.build(:payment, 
      :amount => 0.5, 
      :creditor => @adam, 
      :debitor => @charlie)
    assert bill.payments.include? Fabricate.build(:payment, 
      :amount => 0.5, 
      :creditor => @ben, 
      :debitor => @charlie)
  end
  
  test "two bills payed by one on behalf of two" do
    bill = Fabricate(:bill, :people => [@adam, @ben])
    bill.add_expense Fabricate.build(:expense, 
      :amount => 1,
      :creditors => [@adam], 
      :debitors => [@adam, @ben]
    )
    bill.add_expense Fabricate.build(:expense, 
      :amount => 1,
      :creditors => [@adam], 
      :debitors => [@adam, @ben]
    )
    bill.save
    assert bill.payments.length == 1
    assert bill.payments.include? Fabricate.build(:payment, 
      :amount => 1, 
      :creditor => @adam, 
      :debitor => @ben)
  end
  
  test "two bills payed by two on behalf each other balances out" do
    bill = Fabricate(:bill, :people => [@adam, @ben])
    bill.add_expense Fabricate.build(:expense, 
      :amount => 1,
      :creditors => [@adam], 
      :debitors => [@adam, @ben]
    )
    bill.add_expense Fabricate.build(:expense, 
      :amount => 1,
      :creditors => [@ben], 
      :debitors => [@adam, @ben]
    )
    bill.save
    assert bill.payments.length == 0
  end
  
  test "two bills payed by two on behalf of each other with different amounts" do
    bill = Fabricate(:bill, :people => [@adam, @ben])
    bill.add_expense Fabricate.build(:expense, 
      :amount => 3,
      :creditors => [@adam], 
      :debitors => [@adam, @ben]
    )
    bill.add_expense Fabricate.build(:expense, 
      :amount => 1,
      :creditors => [@ben], 
      :debitors => [@adam, @ben]
    )
    bill.save
    assert bill.payments.length == 1
    assert bill.payments.include? Fabricate.build(:payment, 
      :amount => 1, 
      :creditor => @adam, 
      :debitor => @ben)
  end
  
  test "payments can be optimzed" do
    bill = Fabricate(:bill, :people => [@adam, @ben, @charlie, @dan, @ed])
    bill.add_expense Fabricate.build(:expense, 
      :amount => 300,
      :creditors => [@adam], 
      :debitors => [@dan]
    )
    bill.add_expense Fabricate.build(:expense, 
      :amount => 150,
      :creditors => [@ben], 
      :debitors => [@ed]
    )
    bill.add_expense Fabricate.build(:expense, 
      :amount => 100,
      :creditors => [@charlie], 
      :debitors => [@dan]
    )
    bill.save
    puts "#{@adam.id}, #{@ben.id}, #{@charlie.id}, #{@dan.id}, #{@ed.id}"
    puts bill.payments.inspect
    assert_equal 3, bill.payments.length
    assert bill.payments.include? Fabricate.build(:payment, 
      :amount => 300, 
      :creditor => @adam, 
      :debitor => @dan)
    assert bill.payments.include? Fabricate.build(:payment, 
      :amount => 150, 
      :creditor => @ben, 
      :debitor => @ed)
    assert bill.payments.include? Fabricate.build(:payment, 
      :amount => 100, 
      :creditor => @charlie, 
      :debitor => @dan)
    
  end
end
