# frozen_string_literal: true
class WeeklyBalanceReminder
  include Sidekiq::Worker

  # This method smells of :reek:UtilityFunction
  def perform
    User.find_each do |user|
      balances = filter_balances(user)
      BalanceMailer.debt_email(user, balances).deliver_now if balances.present?
    end
  end

  private

  # This method smells of :reek:UtilityFunction
  def filter_balances(user)
    user.balances.select do |balance|
      balance.balance < 0 &&
        Transfer.pending.where(to: balance.user, from: user).blank?
    end
  end
end # WeeklyBalanceReminder
