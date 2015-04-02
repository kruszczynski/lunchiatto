class DishDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def belongs_to_current_user?
    object.user == current_user
  end

  def order_by_current_user?
    object.order.user == current_user
  end

  def editable?
    (object.order.in_progress? && belongs_to_current_user?) ||
        (object.order.ordered? && order_by_current_user?)
  end

  def deletable?
    object.order.in_progress? && belongs_to_current_user?
  end

  def copyable?
    object.order.in_progress? && !belongs_to_current_user?
  end
end