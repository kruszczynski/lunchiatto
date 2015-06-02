class Company < ActiveRecord::Base
  has_many :users
  has_many :orders
  has_many :invitations

  validates :name, presence: true, uniqueness: true, length: {maximum: 255}

  def users_by_name
    users.by_name
  end
end
