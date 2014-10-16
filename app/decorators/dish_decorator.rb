class DishDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def belongs_to_current_user?
    object.user == current_user
  end

  def order_by_current_user?
    object.order.user == current_user
  end
end