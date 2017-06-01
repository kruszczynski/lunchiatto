# frozen_string_literal: true
# A transfer between users. When accepted creates a UserBalance
# This method smells of :reek:PrimaDonnaMethod
# todo(kruszczynski)
# refactor mark_as_accepted
class Transfer < ActiveRecord::Base
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'

  validates :from, :to, presence: true

  scope :newest_first, -> { order 'created_at desc' }
  scope :from_user, ->(from_id) { where from_id: from_id }
  scope :to_user, ->(to_id) { where to_id: to_id }

  register_currency :pln
  monetize :amount_cents

  enum status: [:pending, :accepted, :rejected]

  def mark_as_accepted!
    accepted!
    to.received_payments.create!(payer: from, balance: amount)
    from.user_balances.create(new_balance_params)
  end

  alias_method :mark_as_rejected!, :rejected!

  private

  def new_balance_params
    payer_balance = from.user_balances
      .newest_for(to.id)
      .try(:balance) || Money.new(0, 'PLN')
    {balance: (payer_balance + amount), payer: to}
  end
end
