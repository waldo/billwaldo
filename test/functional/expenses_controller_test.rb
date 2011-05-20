require 'test_helper'

class ExpensesControllerTest < ActionController::TestCase
  setup do
    @expense = expenses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:expenses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create expense" do
    assert_difference('Expense.count') do
      post :create, expense: @expense.attributes
    end

    assert_redirected_to expense_path(assigns(:expense))
  end

  test "should show expense" do
    get :show, id: @expense.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @expense.to_param
    assert_response :success
  end

  test "should update expense" do
    put :update, id: @expense.to_param, expense: @expense.attributes
    assert_redirected_to expense_path(assigns(:expense))
  end

  test "should destroy expense" do
    assert_difference('Expense.count', -1) do
      delete :destroy, id: @expense.to_param
    end

    assert_redirected_to expenses_path
  end
end
