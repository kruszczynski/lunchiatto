class OrderSerializer < ActiveModel::Serializer
  attributes :id,
             :from,
             :user_id,
             :dishes_count,
             :status,
             :shipping,
             :current_user_ordered?,
             :ordered_by_current_user?,
             :total,
             :date,
             :amount,
             :editable?,
             :deletable?
  has_many :dishes
  has_one :user

  def shipping
    object.shipping.to_s
  end

  def amount
    object.amount.to_s
  end

  def dishes
    object.dishes.by_date.decorate
  end

  def total
    (object.amount+object.shipping).to_s
  end

  def include_dishes?
    !options[:shallow]
  end

  def include_user?
    !options[:shallow]
  end
end
