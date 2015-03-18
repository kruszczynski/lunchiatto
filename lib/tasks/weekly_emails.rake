namespace :weekly_email do
  task send: :environment do
    if Date.today.monday?
      Rake::Task["weekly_email:balance"].invoke
    end
  end

  desc "Sends users an email if they owe someone money"
  task balance: :environment do
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
end