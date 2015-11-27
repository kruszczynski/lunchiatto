# A primary grouping of users
class Company < ActiveRecord::Base
  has_many :users
  has_many :orders
  has_many :invitations

  validates :name, presence: true, uniqueness: true, length: {maximum: 255}

  # Usage def users_by_name
  delegate :by_name, to: :users, prefix: true
end
