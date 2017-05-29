# frozen_string_literal: true
# audit logging.
class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :payer, class_name: 'User'

  validates :user, :payer, :balance_cents, presence: true
  validates :balance_cents, numericality: {greater_than: 0}

  register_currency :pln
  monetize :balance_cents

  scope :newest_first, -> { order(created_at: :desc) }
end
