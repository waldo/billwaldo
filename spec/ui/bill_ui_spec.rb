require "spec_helper"

describe "bill" do
  before :all do
    @browser = BrowserHelper.new
  end

  before :each do
    @browser.go_home
  end

  after :all do
    @browser.close
  end

  it "should create a new named bill" do
    @browser.create_bill "ost"
    @browser.check_bill_name "ost"
  end

  it "should create a new unnamed bill" do
    @browser.create_bill ""
    @browser.check_bill_name "Unnamed"
  end

  it "should create a bill, then add people" do
    @browser.create_bill "ost"
    @browser.add_person "Fred"
    @browser.check_person_name "Fred"
  end
end
