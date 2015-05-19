namespace :daily_emails do
  task send: [:pending_transfers]

  desc "Sends an email to transfer 'tos' every day after 3rd day past submission"
  task pending_transfers: :environment do
    User.find_each do |user|
      transfers = user.received_transfers.newest_first.pending.where("created_at <= ?", Time.now - 3.days)
      TransferMailer.pending_transfers(transfers, user).deliver_now unless transfers.empty?
    end
  end

end
