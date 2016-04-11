# frozen_string_literal: true
class Dish < ActiveRecord::Base
  belongs_to :user
  belongs_to :order, counter_cache: true

  validates :name, presence: true,
                   length: {maximum: 255}
  validates :user, presence: true,
                   uniqueness: {scope: :order_id,
                                message: 'can only order one dish'}
  validates :order, :price_cents, presence: true

  register_currency :pln
  monetize :price_cents

  scope :by_date, -> { order('created_at') }

  def copy(new_user)
    dish = Dish.find_by order: order, user: new_user
    dish.delete if dish
    new_dish = dup
    new_dish.user = new_user
    new_dish
  end

  def subtract(shipping, payer)
    user.subtract(price + shipping, payer)
  end
end
