require 'test_helper'

class BillTest < ActiveSupport::TestCase
  test "bill type a" do
    bill = Fabricate(:abc)
    assert bill.expenses.first.creditors.first.name == "adam"
    bill.save
    assert bill.payments.first == Fabricate(:payment_abc_0)
  end
end
