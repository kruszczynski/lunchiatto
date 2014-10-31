class DishSerializer < ActiveModel::Serializer
  attributes :user_name, :price, :name

  def price
    object.price.to_s
  end

  delegate :name, to: :user, prefix: true
  delegate :user, to: :object
end