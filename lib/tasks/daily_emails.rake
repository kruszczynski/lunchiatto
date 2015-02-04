namespace :daily_emails do
  task send: [:balance, :pending_transfers]

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
  
  desc "Sends an email to transfer 'tos' every day after 3rd day past submission"
  task pending_transfers: :environment do
    User.find_each do |user|
      transfers = user.received_transfers.newest_first.pending.where("created_at <= ?", Time.now - 3.days)
      TransferMailer.pending_transfers(transfers, user).deliver_now unless transfers.empty?
    end
  end

end
