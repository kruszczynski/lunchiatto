class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_order, except: [:create, :index, :latest]

  def index
    @orders = Order.past.includes(:dishes).decorate
    respond_to do |format|
      format.json {render json: @orders}
    end
  end

  def create
    @order = Order.new order_params.merge(date: Date.today)
    if @order.save
      respond_to do |format|
        format.json {render json: @order.decorate}
      end
    else
      respond_to do |format|
        format.json {render json: {errors: @order.errors}, status: :unprocessable_entity}
      end
    end
  end

  def show
    @order = @order.decorate
    respond_to do |format|
      format.json { render json: @order }
    end
  end

  def update
    if @order.update(order_params)
      respond_to do |format|
        format.json { render json: @order.decorate }
      end
    else
      respond_to do |format|
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

  def latest
    @order = Order.todays_order.try(:decorate)
    respond_to do |format|
      format.json { render json: @order }
    end
  end

  private

  def order_params
    params.permit(:user_id, :from, :shipping)
  end

  def find_order
    @order = Order.find params[:id]
  end
end
