# frozen_string_literal: true
# A transfer between users. When accepted creates a Payment
# This method smells of :reek:PrimaDonnaMethod
# todo(kruszczynski)
# refactor mark_as_accepted
class Transfer < ActiveRecord::Base
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'

  validates :from, :to, presence: true
  validate :cannot_transfer_to_self

  scope :newest_first, -> { order 'created_at desc' }
  scope :from_user, ->(from_id) { where from_id: from_id }
  scope :to_user, ->(to_id) { where to_id: to_id }

  register_currency :pln
  monetize :amount_cents

  enum status: %i(pending accepted rejected)

  def mark_as_accepted!
    accepted!
    to.received_payments.create!(payer: from, balance: amount)
  end

  alias_method :mark_as_rejected!, :rejected!

  private

  def cannot_transfer_to_self
    return unless to == from
    errors.add(:base, "Can't send transfers to yourself")
  end
end
