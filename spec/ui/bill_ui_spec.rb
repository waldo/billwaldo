require "spec_helper"
require "watir-webdriver"

describe "bill" do
  before :all do
    @browser = Watir::Browser.new :chrome
  end

  before :each do
    @browser.goto "http://localhost:3000/"
    @browser.h1.text.should == "Bill Waldo"
  end

  after :all do
    @browser.close
  end

  it "should create a new named bill" do
    @browser.text_field(:id => "bill_name").set("ost")
    @browser.button(:name => "commit").click
    @browser.h1.text.should == "ost - Bill"
  end

  it "should create a new unnamed bill" do
    @browser.button(:name => "commit").click
    @browser.h1.text.should == "Unnamed - Bill"
  end

  it "should create a bill, then add people" do
    @browser.text_field(:id => "bill_name").set("ost")
    @browser.button(:name => "commit").click
    @browser.h1.text.should == "ost - Bill"
    @browser.text_field( :id => "person_name").set("Joe")
    @browser.button(:value => "Create Person").click
    sleep 1
    Watir::Wait.until {
      @browser.select_list(:id => "expense_creditors").select("Joe")
    }
  end
end
