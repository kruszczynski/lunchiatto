class DishPresenter
  include Rails.application.routes.url_helpers
  include ActionView::Helpers

  attr_reader :dish, :current_user

  def initialize(dish, current_user)
    @dish = dish
    @current_user = current_user
  end

  def table_buttons
    (edit_button.to_s + delete_button.to_s + copy_button.to_s).html_safe
  end

  def edit_button
    if (dish.belongs_to_current_user? && !dish.order.delivered?) ||
        (dish.order_by_current_user? && dish.order.ordered?)
      link_to 'Edit', edit_order_dish_path(dish.order, dish), class: 'margin-right-small'
    end
  end

  def delete_button
    if dish.belongs_to_current_user? && dish.order.in_progress?
      link_to 'Delete', order_dish_path(dish.order, dish), data: {confirm: 'Are you sure?'}, method: :delete
    end
  end

  def copy_button
    if (!dish.belongs_to_current_user? && dish.order.in_progress?)
      link_to 'Copy', copy_order_dish_path(dish.order, dish), data: {confirm: 'This will overwrite your current dish! Are you sure?'}
    end
  end
end