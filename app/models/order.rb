class Order < ActiveRecord::Base
  belongs_to :user
  has_many :dishes, dependent: :destroy

  validates :user, presence: true
  validates :from, presence: true, uniqueness: {scope: :date, message: "There already is an order from there today"}

  scope :newest_first, -> { order(date: :desc, created_at: :desc) }
  scope :as_created, -> { order(created_at: :asc) }
  scope :today, -> { as_created.where(date: Time.zone.today) }

  register_currency :pln
  monetize :shipping_cents

  enum status: [:in_progress, :ordered, :delivered]

  def amount
    initial = Money.new(0, "PLN")
    dishes.inject(initial) {|sum, dish| sum + dish.price }
  end

  def change_status!
    int_status = Order.statuses[status]
    if int_status < Order.statuses.count - 1
      self.status = int_status+1
      subtract_price if int_status == 1
      save!
    end
  end

  def subtract_price
    return if dishes_count == 0
    dishes.each do |dish|
      dish.subtract shipping/(dishes_count), user
    end
  end
end
