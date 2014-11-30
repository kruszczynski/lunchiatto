class UserDebtsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user_debts

  def index
    respond_to do |format|
      format.json { render json: @balances }
    end
  end

  private

  def find_user_debts
    @balances = UserBalanceDecorator.decorate_collection(current_user.debts)
  end
end