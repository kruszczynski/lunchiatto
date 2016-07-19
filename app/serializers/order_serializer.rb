# frozen_string_literal: true
class OrderSerializer < ActiveModel::Serializer
  attributes :amount,
             :current_user_ordered?,
             :date,
             :deletable?,
             :dishes_count,
             :editable?,
             :from,
             :from_today?,
             :id,
             :ordered_by_current_user?,
             :shipping,
             :status,
             :total,
             :user_id

  has_many :dishes
  has_one :user

  def shipping
    object.shipping.to_s
  end

  def amount
    object.amount.to_s
  end

  def dishes
    object.dishes.by_name.decorate
  end

  def total
    (object.amount + object.shipping).to_s
  end

  def include_dishes?
    !options[:shallow]
  end

  def include_user?
    !options[:shallow]
  end

  def editable?
    policy.update?
  end

  def deletable?
    policy.destroy?
  end

  private

  def policy
    @policy ||= OrderPolicy.new current_user, object
  end
end
