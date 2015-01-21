class DishesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_order
  before_filter :find_dish, only: [:copy, :destroy, :update, :show]

  def create
    @dish = @order.dishes.build(dish_params)
    if @dish.save
      render json: @dish.decorate
    else
      render json: {errors: @dish.errors}, status: :unprocessable_entity
    end
  end

  def show
    render json: @dish.decorate
  end

  def update
    if @dish.update(dish_params)
      render json: @dish.decorate
    else
      render json: {errors: @dish.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @dish.delete
    render json: {status: 'success'}
  end

  def copy
    @new_dish = @dish.copy(current_user)
    if @new_dish.save
      render json: @new_dish.decorate
    else
      render json: {errors: @new_dish.errors}, status: :unprocessable_entity
    end
  end

  private

  def find_order
    @order = Order.find(params[:order_id])
  end

  def find_dish
    @dish = @order.dishes.find(params[:id])
  end

  def dish_params
    params.permit(:user_id, :name, :price)
  end
end