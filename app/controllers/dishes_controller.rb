class DishesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_order
  before_filter :find_dish, only: [:copy, :destroy, :edit, :update]

  def new
    @dish = @order.dishes.build
  end

  def create
    @dish = @order.dishes.build(dish_params)
    if @dish.save
      respond_to do |format|
        format.html { redirect_to dashboard_users_path }
        format.json { render json: @dish.decorate }
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = @dish.errors.full_messages.join(' ')
          render :new
        end
        format.json { render json: {errors: @dish.errors}, status: :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    if @dish.update(dish_params)
      respond_to do |format|
        format.html { redirect_to dashboard_users_path }
        format.json { render json: @dish.decorate }
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = @dish.errors.full_messages.join(' ')
          render :edit
        end
        format.json { render json: {errors: @dish.errors}, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @dish.delete
    respond_to do |format|
      format.html { redirect_to dashboard_users_path }
      format.json { render json: {status: 'success'} }
    end
  end

  def copy
    @new_dish = @dish.copy(current_user)
    if @new_dish.save
      respond_to do |format|
        format.html { redirect_to dashboard_users_path }
      end
    else
      respond_to do |format|
        format.html { redirect_to dashboard_users_path, alert: @new_dish.errors.full_messages.join(' ') }
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
    params.require(:dish).permit(:user_id, :name, :price)
  end
end