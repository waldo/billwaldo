require "watir-webdriver"

class BrowserHelper
  def initialize( type = :chrome )
    @browser = Watir::Browser.new type
  end
  
  def go_home
    @browser.goto "http://localhost:3000/"
    @browser.h1.text.should == "Bill Waldo"
  end
  
  def create_bill(name)
    @browser.text_field(:id => "bill_name").set(name)
    @browser.button(:name => "commit").click
  end
  
  def check_bill_name(name)
    @browser.h1.text.should == "#{name} - Bill"
  end
  
  def add_person(name)
    @browser.text_field( :id => "person_name").set(name)
    @browser.button(:value => "Create Person").click
  end

  def check_person_name(name)
    Watir::Wait.until do
      @browser.element(:xpath => "//select[@id='expense_creditors']/option[text()='#{name}']").exists?
    end
  end
  
  def close
    @browser.close
  end
end
