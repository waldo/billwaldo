require 'test_helper'

class BillTest < ActiveSupport::TestCase
  
  setup do
    @adam = Fabricate(:adam)
    @ben = Fabricate(:ben)
    @charlie = Fabricate(:charlie)
    # @dan = Fabricate(:dan)
    # @ed = Fabricate(:ed)
  end
  
  test "bill payed by one on behalf of two" do
    bill = Fabricate(:bill, :people => [@adam, @ben])
    bill.expenses << Fabricate.build(:expense, 
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
  
  test "bill payed by one on behalf of three" do
    bill = Fabricate(:bill, :people => [@adam, @ben, @charlie])
    bill.expenses << Fabricate.build(:expense, 
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
end
