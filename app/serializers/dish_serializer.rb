# frozen_string_literal: true
class DishSerializer < ActiveModel::Serializer
  attributes :belongs_to_current_user,
             :copyable,
             :deletable,
             :editable,
             :from_today,
             :id,
             :name,
             :order_id,
             :price,
             :user_id,
             :user_name

  def price
    object.price.to_s
  end

  def user_name
    object.user.name
  end

  def editable
    policy.update?
  end

  def deletable
    policy.destroy?
  end

  def copyable
    policy.copy?
  end

  def from_today
    object.order.from_today?
  end

  def belongs_to_current_user
    object.user == current_user
  end

  private

  def policy
    @policy ||= DishPolicy.new current_user, object
  end
end
