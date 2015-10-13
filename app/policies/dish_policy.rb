class DishPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    (order.in_progress? && record_belongs_to_user?) ||
      (order.ordered? && order_by_current_user?)
  end

  def show?
    true
  end

  def destroy?
    order.in_progress? && record_belongs_to_user?
  end

  def copy?
    order.in_progress? && !record_belongs_to_user?
  end

  private

  def order
    @order ||= record.order
  end

  def order_by_current_user?
    order.user_id == user.id
  end
end
