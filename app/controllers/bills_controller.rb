class BillsController < ApplicationController
  def new
    @bill = Bill.new

    # TODO: move this kludge client-side with jquery function to generate extra people fields on demand
    10.times do
      @bill.people << Person.new
    end

    respond_to do |format|
      format.html
    end
  end

  def create
    bill_params = params[:bill]
    bill_params[:people_attributes].reject! do |key, val| val[:email].blank? end 

    @bill = Bill.new(:name => bill_params[:name])

    bill_params[:people_attributes].each do |key, val|
      p = Person.where(:email => val[:email]).first
      unless p
        p = Person.new(val)
        p.save
      end
      @bill.people << p
    end

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
end