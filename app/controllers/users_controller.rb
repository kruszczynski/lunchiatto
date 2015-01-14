class UsersController < ApplicationController
  before_action :authenticate_user!
  before_filter :only_current_user, only: [:my_balances]
  before_filter :find_user, only: [:show]

  def index
    @users = User.all.order('name')
    respond_to do |format|
      format.json {render json: @users}
    end
  end

  def show
    respond_to do |format|
      format.json {render json: @user}
    end
  end

  def update
    @user = current_user
    if @user.update(user_params)
      respond_to do |format|
        format.json {render json: @user}
      end
    else
      respond_to do |format|
        format.json {render json: {errors: @user.errors}, status: :unprocessable_entity}
      end
    end
  end

  private

  def user_params
    params.permit(:substract_from_self, :account_number)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def only_current_user
    return if find_user == current_user
    redirect_to dashboard_users_path, alert: 'You can\' view others balances'
  end

end
