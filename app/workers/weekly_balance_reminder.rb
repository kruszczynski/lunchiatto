class WeeklyBalanceReminder
  include Sidekiq::Worker

  def perform
    User.find_each do |user|
      balances = user.balances.select do |balance|
        balance.balance_cents < 0
      end
      balances = balances.select do |balance|
        Transfer.pending.where(to: balance.payer, from: user).blank?
      end
      BalanceMailer.debt_email(user, balances).deliver_now if balances.present?
    end
  end
end # WeeklyBalanceReminder
