class ExpensesController < ApplicationController
  # POST /bills/:uuid/expenses
  def create
    logger.debug(params.inspect)

    @bill = Bill.where(:uuid => params[:uuid]).first
    @expense = Expense.new params[:expense]
    @bill.add_expense(@expense)
    
    if @bill.save
      notice = "#{@expense.description} - saved."
    else
      notice = "Eep, something went wrong saving your expense."
    end
    
    respond_to do |format|
      format.html { redirect_to bills_view_path(@bill.uuid), notice: notice }
    end
  end

  # DELETE /bills/:uuid/expenses/1
  # TODO: so people can remove mistaken expenses
  def destroy
    @bill = Bill.where(:uuid => params[:uuid]).first
    @expense = Expense.find(params[:id])
    @expense.destroy

    respond_to do |format|
      format.html { redirect_to bills_view_path(@bill.uuid) }
    end
  end
end
