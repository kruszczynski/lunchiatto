class Api::DishesController < ApplicationController
  before_action :authenticate_user!

  def create
    order = find_order
    dish = order.dishes.build(dish_params)
    authorize dish
    if dish.save
      render json: dish.decorate
    else
      render json: {errors: dish.errors}, status: :unprocessable_entity
    end
  end

  def show
    dish = find_dish
    authorize dish
    render json: dish.decorate
  end

  def update
    dish = find_dish
    authorize dish
    if dish.update(dish_params)
      render json: dish
    else
      render json: {errors: dish.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    dish = find_dish
    authorize dish
    if dish.delete
      render json: {status: 'success'}
    else
      render json: {errors: dish.errors}, status: :unprocessable_entity
    end
  end

  def copy
    dish = find_dish
    authorize dish
    new_dish = dish.copy(current_user)
    if new_dish.save
      render json: new_dish.decorate
    else
      render json: {errors: new_dish.errors}, status: :unprocessable_entity
    end
  end

  private

  def find_order
    Order.find(params[:order_id])
  end

  def find_dish
    find_order.dishes.find(params[:id]).decorate
  end

  def dish_params
    params.permit(:user_id, :name, :price)
  end
end