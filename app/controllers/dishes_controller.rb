class DishesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_order
  before_filter :find_dish, only: [:copy, :destroy, :update, :show]

  def create
    @dish = @order.dishes.build(dish_params)
    if @dish.save
      respond_to do |format|
        format.json { render json: @dish.decorate }
      end
    else
      respond_to do |format|
        format.json { render json: {errors: @dish.errors}, status: :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @dish.decorate }
    end
  end

  def update
    if @dish.update(dish_params)
      respond_to do |format|
        format.json { render json: @dish.decorate }
      end
    else
      respond_to do |format|
        format.json { render json: {errors: @dish.errors}, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @dish.delete
    respond_to do |format|
      format.json { render json: {status: 'success'} }
    end
  end

  def copy
    @new_dish = @dish.copy(current_user)
    if @new_dish.save
      respond_to do |format|
        format.json { render json: @new_dish.decorate }
      end
    else
      respond_to do |format|
        format.json { render json: {errors: @new_dish.errors}, status: :unprocessable_entity }
      end
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