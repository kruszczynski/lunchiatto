class DishDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def belongs_to_current_user?
    user == current_user
  end

  def order_by_current_user?
    order.user == current_user
  end

  def from_today?
    order.date.today?
  end
end
