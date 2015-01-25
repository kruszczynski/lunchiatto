namespace :daily_emails do
  task send: [:balance]

  desc 'Sends users an email if they owe someone money'
  task balance: :environment do
    User.find_each do |user|
      balances = user.balances.select do |balance|
        balance.balance_cents < 0
      end
      BalanceMailer.debt_email(user, balances).deliver_now if balances.present?
    end
  end

end
