class OrderSerializer < ActiveModel::Serializer
  attributes :id, :from, :user_id, :dishes_count, :status, :shipping, :current_user_ordered?, :ordered_by_current_user?, :total
  has_many :dishes
  has_one :user

  def shipping
    object.shipping.to_s
  end

  def total
    (object.amount+object.shipping).to_s
  end
end