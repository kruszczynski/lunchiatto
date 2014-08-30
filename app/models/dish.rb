class Dish < ActiveRecord::Base
  belongs_to :user
  belongs_to :order, counter_cache: true

  validates :price_cents, numericality: true, presence: true
  validates :name, presence: true

  before_create :ensure_uniqueness

  scope :by_date, -> {order('created_at')}

  def ensure_uniqueness
    if Dish.find_by order: order, user: user
      errors[:base] << 'You can have only one dish in an order'
      return false
    end
    true
  end

  def copy(new_user)
    new_dish = dup
    new_dish.user = new_user
    new_dish
  end
end