class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize Order
    @orders = Order.newest_first.page(params[:page]).includes(:dishes).decorate
    render json: @orders, shallow: true
  end

  def create
    order = Order.new order_params.merge(date: Time.zone.today)
    authorize order, :index?
    if order.save
      render json: order.decorate
    else
      render json: {errors: order.errors}, status: :unprocessable_entity
    end
  end

  def show
    order = find_order
    authorize order, :index?
    render json: order
  end

  def update
    order = find_order
    authorize order
    if order.update(order_params)
      render json: order
    else
      render json: {errors: order.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    order = find_order
    authorize order
    if order.destroy
      render json: {status: "success"}
    else
      render json: {error: ["You can't delete this order."]}, status: :unprocessable_entity
    end
  end

  def change_status
    order = find_order
    authorize order
    if order.change_status!
      render json: order
    else
      render json: {errors: ["Operation not allowed"]}, status: :unprocessable_entity
    end
  end

  def latest
    orders = find_todays_orders
    authorize Order, :index?
    render json: orders, shallow: true
  end

  private

  def order_params
    params.permit(:user_id, :from, :shipping)
  end

  def find_order
    Order.find(params[:id]).decorate
  end

  def find_todays_orders
    Order.today.decorate
  end
end
