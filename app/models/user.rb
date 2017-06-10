# frozen_string_literal: true
class User < ActiveRecord::Base
  has_many :orders

  has_many :received_payments, inverse_of: :user,
                               class_name: 'Payment',
                               foreign_key: 'user_id'
  has_many :submitted_transfers, inverse_of: :from,
                                 class_name: 'Transfer',
                                 foreign_key: :from_id
  has_many :received_transfers, inverse_of: :to,
                                class_name: 'Transfer',
                                foreign_key: :to_id
  belongs_to :company

  scope :by_name, -> { order 'name' }
  scope :admin, -> { where admin: true }

  devise :database_authenticatable,
         :rememberable,
         :trackable,
         :omniauthable,
         omniauth_providers: [:google_oauth2]

  def balances
    balance = Balance.new(self)
    company
      .users
      .map { |usr| balance.build_wrapper(usr) }
      .reject { |bal| bal.balance.zero? }
  end

  def subtract(amount, payer)
    return if self == payer
    return if amount.zero?
    received_payments.create!(balance: amount, payer: payer)
  end

  def to_s
    name
  end

  def payer_balance(payer)
    balance.balance_for(payer)
  end

  def total_balance
    balance.total
  end

  def debt_to(user)
    balance.balance_for(user)
  end

  def total_debt
    total_balance
  end

  def pending_transfers_count
    received_transfers.pending.size
  end

  private

  def balance
    @balance ||= Balance.new(self)
  end
end
