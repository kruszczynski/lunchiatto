class UserBalancesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user_balances

  def index
    respond_to do |format|
      format.json { render json: @balances }
    end
  end

  private

  def find_user_balances
    @balances = UserBalanceDecorator.decorate_collection(current_user.balances)
  end
end