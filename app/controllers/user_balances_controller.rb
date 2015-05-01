class UserBalancesController < ApplicationController
  before_action :authenticate_user!

  def index
    balances = find_user_balances
    render json: balances
  end

  private

  def find_user_balances
    UserBalanceDecorator.decorate_collection(current_user.balances)
  end
end