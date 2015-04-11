class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_order, except: [:create, :index, :latest]

  def index
    @orders = Order.newest_first.page(params[:page]).includes(:dishes).decorate
    render json: @orders, shallow: true
  end

  def create
    @order = Order.new order_params.merge(date: Date.today)
    if @order.save
      render json: @order.decorate
    else
      render json: {errors: @order.errors}, status: :unprocessable_entity
    end
  end

  def show
    render json: @order
  end

  def update
    if @order.editable? && @order.update(order_params)
      render json: @order
    else
      render json: {errors: @order.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    if @order.deletable? && @order.destroy
      render json: {status: "success"}
    else
      render json: {error: ["You can't delete this order."]}, status: :unprocessable_entity
    end
  end

  def change_status
    if @order.can_change_status? && @order.change_status!
      render json: @order
    else
      render json: {errors: ["Operation not allowed"]}, status: :unprocessable_entity
    end
  end

  def latest
    @order = Order.todays_order.try(:decorate)
    render json: @order
  end

  private

  def order_params
    params.permit(:user_id, :from, :shipping)
  end

  def find_order
    @order = Order.find(params[:id]).decorate
  end
end
