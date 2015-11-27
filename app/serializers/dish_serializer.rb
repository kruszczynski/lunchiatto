# Serialize Dish for API
class DishSerializer < ActiveModel::Serializer
  attributes :id,
             :user_name,
             :price,
             :name,
             :belongs_to_current_user?,
             :editable?,
             :deletable?,
             :copyable?,
             :order_id,
             :user_id,
             :from_today?

  def price
    object.price.to_s
  end

  def user_name
    object.user.name
  end

  def editable?
    policy.update?
  end

  def deletable?
    policy.destroy?
  end

  def copyable?
    policy.copy?
  end

  private

  def policy
    @policy ||= DishPolicy.new current_user, object
  end
end
