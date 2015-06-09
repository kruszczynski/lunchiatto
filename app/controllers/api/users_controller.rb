class Api::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    users = current_user.company.users_by_name
    render json: users, with_balance: true
  end

  def show
    user = find_user
    render json: user
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: user
    else
      render json: {errors: user.errors}, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:substract_from_self, :account_number)
  end

  def find_user
    User.find(params[:id])
  end
end
