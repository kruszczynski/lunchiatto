# frozen_string_literal: true
class Balance
  include ActiveModel::Model

  def initialize(user)
    @user = user
  end

  # returns the total account balance for user
  def total
    Money.new(Payment.where(payer: user).sum(:balance_cents) -
      Payment.where(user: user).sum(:balance_cents), 'PLN')
  end

  # returns the current balance between user and other
  def balance_for(other_user)
    raise ArgumentError if other_user == user
    Money.new(payments_as_payer(other_user).sum(:balance_cents) -
      payments_as_beneficiary(other_user).sum(:balance_cents), 'PLN')
  end

  # returns a list of all debts and credits for user and other
  def payments_for(other_user)
    raise NotImplementedError
  end

  private

  attr_reader :user

  def payments_as_beneficiary(other_user)
    Payment.where(payer: other_user, user: user)
  end

  def payments_as_payer(other_user)
    Payment.where(payer: user, user: other_user)
  end
end
