class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :assign_users, only: [:edit, :new]
  before_filter :find_order, except: [:new, :create, :index, :latest]

  def new
    @order = Order.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @order = Order.new order_params.merge(date: Date.today)
    if @order.save
      respond_to do |format|
        format.html {redirect_to dashboard_users_path}
        format.json {render json: @order.decorate}
      end
    else
      respond_to do |format|
        format.html {redirect_to new_order_path, alert: @order.errors.full_messages.join(' ')}
        format.json {render json: {errors: @order.errors}, status: :unprocessable_entity}
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    if @order.update(order_params)
      respond_to do |format|
        format.html {redirect_to dashboard_users_path}
        format.json { render json: @order.decorate }
      end
    else
      respond_to do |format|
        format.html {redirect_to edit_order_path(@order), alert: @order.errors.full_messages.join(' ')}
        format.json {render json: {errors: @order.errors}, status: :unprocessable_entity}
      end
    end
  end

  def change_status
    @order.change_status!
    respond_to do |format|
      format.html {redirect_to dashboard_users_path}
      format.json {render json: @order.decorate}
    end
  end

  def shipping
    respond_to do |format|
      format.html
    end
  end

  def index
    @orders = Order.past.includes(:dishes).decorate
    respond_to do |format|
      format.html
      format.json {render json: @orders}
    end
  end

  def show
    @order = @order.decorate
    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end

  def latest
    @order = Order.todays_order.try(:decorate)
    respond_to do |format|
      format.json { render json: @order }
    end
  end

  private

  def assign_users
    @users = User.all.by_name.map do |user|
      [user.name, user.id]
    end
  end

  def order_params
    params.require(:order).permit(:user_id, :from, :shipping)
  end

  def find_order
    @order = Order.find params[:id]
  end
end
