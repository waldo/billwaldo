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
end
