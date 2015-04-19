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

  delegate :name, to: :user, prefix: true
  delegate :user, to: :object
end