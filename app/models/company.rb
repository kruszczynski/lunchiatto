class Company < ActiveRecord::Base
  has_many :users
  has_many :orders

  validates :name, presence: true, uniqueness: true

  def users_by_name
    users.by_name
  end
end
