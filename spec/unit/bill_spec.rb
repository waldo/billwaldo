require "spec_helper"
require "fabrication"

describe "bill" do
  before :all do
    @adam = Fabricate :adam
    @ben = Fabricate :ben
    @charlie = Fabricate :charlie
    @dan = Fabricate :dan
    @ed = Fabricate :ed
  end
  
  it "should allow a bill with no title" do
    bill = Fabricate :bill, :people => []
    bill.save

    bill.name.should == "Unnamed"
    bill.payments.length.should == 0
  end

  it "shouldn't create any payment for expenses that are for myself" do
    bill = Fabricate :bill, :people => [ @adam, @ben ]
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 2,
      :creditors => [ @adam ],
      :debitors => [ @adam ],
    )
    bill.save

    bill.payments.length.should == 0
  end

  it "should create a single payment (1 person paid for 2)" do
    bill = Fabricate :bill, :people => [ @adam, @ben ]
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 2,
      :creditors => [ @adam ], 
      :debitors => [ @adam, @ben ],
    )
    bill.save

    bill.payments.length.should == 1    
    bill.payments.should include Fabricate.build(
      :payment,
      :amount => 1,
      :creditor => @adam,
      :debitor => @ben,
    )
  end

  it "should create two payments (1 person paid for 2 excluding himself)" do
    bill = Fabricate :bill, :people => [ @adam, @ben, @charlie ]
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 2,
      :creditors => [ @adam ], 
      :debitors => [ @charlie, @ben ],
    )
    bill.save

    bill.payments.length.should == 2   
    bill.payments.should include Fabricate.build(
      :payment,
      :amount => 1,
      :creditor => @adam,
      :debitor => @ben,
    )
    bill.payments.should include Fabricate.build(
      :payment,
      :amount => 1,
      :creditor => @adam,
      :debitor => @charlie,
    )    
  end

  it "should create two payments (1 person paid for 3)" do
    bill = Fabricate :bill, :people => [ @adam, @ben, @charlie ]
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 3,
      :creditors => [ @adam ],
      :debitors => [ @adam, @ben, @charlie ],
    )
    bill.save

    bill.payments.length.should == 2
    bill.payments.should include Fabricate.build(
      :payment,
      :amount => 1, 
      :creditor => @adam, 
      :debitor => @ben,
    )
    bill.payments.should include Fabricate.build(
      :payment,
      :amount => 1, 
      :creditor => @adam, 
      :debitor => @charlie,
    )
  end

  it "should create two payments (2 people paid for 3)" do
    bill = Fabricate :bill, :people => [ @adam, @ben, @charlie ]
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 3,
      :creditors => [@adam, @ben], 
      :debitors => [@adam, @ben, @charlie],
    )
    bill.save

    bill.payments.length.should == 2
    bill.payments.should include Fabricate.build(
      :payment,
      :amount => 0.5, 
      :creditor => @adam, 
      :debitor => @charlie,
    )
    bill.payments.should include Fabricate.build(
      :payment,
      :amount => 0.5, 
      :creditor => @ben, 
      :debitor => @charlie,
    )
  end

  it "should create one payment for two expenses (1 person paid for 2)" do
    bill = Fabricate :bill, :people => [ @adam, @ben ]
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 1,
      :creditors => [ @adam ],
      :debitors => [ @adam, @ben ],
    )
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 1,
      :creditors => [ @adam ], 
      :debitors => [ @adam, @ben ],
    )
    bill.save

    bill.payments.length.should == 1
    bill.payments.should include Fabricate.build(
      :payment,
      :amount => 1, 
      :creditor => @adam, 
      :debitor => @ben,
    )
  end

  it "should create no payments for two expenses (that exactly offset each other)" do
    bill = Fabricate :bill, :people => [ @adam, @ben ]
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 1,
      :creditors => [ @adam ],
      :debitors => [ @adam, @ben ],
    )
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 1,
      :creditors => [ @ben ], 
      :debitors => [ @adam, @ben ],
    )
    bill.save

    bill.payments.length.should == 0
  end

  it "should create one payment for two expenses (paid by 2 on behalf of each other with different amounts)" do
    bill = Fabricate :bill, :people => [ @adam, @ben ]
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 3,
      :creditors => [ @adam ],
      :debitors => [ @adam, @ben ],
    )
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 1,
      :creditors => [ @ben ],
      :debitors => [ @adam, @ben ],
    )
    bill.save

    bill.payments.length.should == 1
    bill.payments.should include Fabricate.build(
      :payment,
      :amount => 1,
      :creditor => @adam,
      :debitor => @ben,
    )
  end

  it "should optimize the number of payments" do
    bill = Fabricate :bill, :people => [ @adam, @ben, @charlie, @dan, @ed ]
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 300,
      :creditors => [ @adam ],
      :debitors => [ @dan ],
    )
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 150,
      :creditors => [ @ben ],
      :debitors => [ @ed ],
    )
    bill.add_expense Fabricate.build(
      :expense,
      :amount => 100,
      :creditors => [ @charlie ],
      :debitors => [ @dan ],
    )
    bill.save

    bill.payments.length.should == 3
    bill.payments.should include Fabricate.build(
      :payment,
      :amount => 300, 
      :creditor => @adam, 
      :debitor => @dan,
    )
    bill.payments.should include Fabricate.build(
      :payment,
      :amount => 150, 
      :creditor => @ben,
      :debitor => @ed,
    )
    bill.payments.should include Fabricate.build(
      :payment,
      :amount => 100,
      :creditor => @charlie,
      :debitor => @dan,
    )
  end
end
