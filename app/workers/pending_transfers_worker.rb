class PendingTransfersWorker
  include Sidekiq::Worker

  # This method smells of :reek:UtilityFunction
  def perform
    User.find_each do |user|
      transfers =
        user.received_transfers.newest_first.pending
        .where('created_at <= ?', Time.zone.now - 3.days)
      next if transfers.empty?
      TransferMailer.pending_transfers(transfers, user).deliver_now
    end
  end
end # class PendingTransfersWorker
