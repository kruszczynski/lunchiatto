class OrderSerializer < ActiveModel::Serializer
  attributes :id, :from, :user_id, :dishes_count, :status, :shipping, :current_user_ordered?, :ordered_by_current_user?
  has_many :dishes

  def shipping
    object.shipping.to_s
  end
end