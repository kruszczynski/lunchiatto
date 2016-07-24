# frozen_string_literal: true
class Balance
  include ActiveModel::Model

  def initialize(user)
    @user = user
  end

  # returns the total account balance for user
  def total
    Money.new(payments_as_payer.sum(:balance_cents) -
      payments_as_beneficiary.sum(:balance_cents), 'PLN')
  end

  # returns the current balance between user and other
  def balance_for(other_user)
    fail ArgumentError if other_user == user
    Money.new(
      payments_as_payer.where(user: other_user).sum(:balance_cents) -
          payments_as_beneficiary.where(payer: other_user).sum(:balance_cents),
      'PLN',
    )
  end

  # returns a list of all debts and credits for user and other
  def payments_for(_other_user)
    fail NotImplementedError
  end

  private

  attr_reader :user

  def payments_as_beneficiary
    Payment.where(user: user)
  end

  def payments_as_payer
    Payment.where(payer: user)
  end
end
