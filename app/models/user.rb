# frozen_string_literal: true
class User < ActiveRecord::Base
  has_many :orders
  has_many :user_balances, dependent: :destroy
  has_many :balances_as_payer, class_name: 'UserBalance',
                               inverse_of: :payer,
                               foreign_key: :payer_id
  has_many :submitted_transfers, inverse_of: :from,
                                 class_name: 'Transfer',
                                 foreign_key: :from_id
  has_many :received_transfers, inverse_of: :to,
                                class_name: 'Transfer',
                                foreign_key: :to_id
  belongs_to :company

  after_create :add_first_balance

  scope :by_name, -> { order 'name' }
  scope :admin, -> { where admin: true }

  devise :database_authenticatable,
         :rememberable,
         :trackable,
         :omniauthable,
         omniauth_providers: [:google_oauth2]

  def balances
    # TODO(janek): list Balances for all unique users in payments table
    @balances ||= UserBalance.balances_for(self)
  end

  def debts
    # TODO(janek): list Balances for all unique users in payments table
    @debts ||= UserBalance.debts_to(self)
  end

  def add_first_balance
    # TODO(janek): no need to double write here
    user_balances.create balance: 0, payer: self
  end

  def subtract(amount, payer)
    # TODO(janek): double write to new model!
    return if self == payer && !subtract_from_self
    user_balances.create(balance: payer_balance(payer) - amount, payer: payer)
  end

  def to_s
    name
  end

  def payer_balance(payer)
    # TODO(janek): proposed impl
    # Balance.new(self).balance_for(payer)
    user_balances.newest_for(payer.id).try(:balance) || Money.new(0, 'PLN')
  end

  def total_balance
    # TODO(janek): proposed impl
    # Balance.new(self).total
    balances.map(&:balance).reduce :+
  end

  def debt_to(user)
    # TODO(janek): get rid of this method and fix usages
    balances.find { |balance| balance.payer_id == user.id }.try(:balance)
  end

  def total_debt
    # rubocop:disable Style/SingleLineBlockParams
    # TODO(janek): get rid of this method and fix usages
    debts.inject(Money.new(0, 'PLN')) { |sum, debt| sum + debt.balance }
  end

  def pending_transfers_count
    received_transfers.pending.size
  end
end
