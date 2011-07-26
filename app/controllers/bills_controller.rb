class BillsController < ApplicationController
  def new
    @bill = Bill.new

    respond_to do |format|
      format.html
    end
  end

  def create
    bill_params = params[:bill]

    @bill = Bill.new(:name => bill_params[:name])

    respond_to do |format|
      if @bill.save
        format.html { redirect_to bills_view_path(@bill.uuid) }
      else
        format.html { render :action => :new }
      end
    end
  end

  def show
    @bill = Bill.where(:uuid => params[:uuid]).first

    respond_to do |format|
      if @bill
        format.html
      else
        format.html { redirect_to root_path, :notice => "Sorry, we couldn't find your bill." }
      end
    end
  end

  def add_person
    @bill = Bill.where( :uuid => params[ :uuid ]).first
    @bill.people << Person.new( params[ :person ])
    @bill.reload

    respond_to do |format|
      format.html { render :partial => "expenses/form" }
    end
  end
end