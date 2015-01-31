class ChangeTransferStatus
  attr_reader :transfer, :user
  def initialize(transfer, user)
    @transfer = transfer
    @user = user
  end

  def change_status(new_status)
    return false unless user == transfer.to && transfer.pending?
    transfer.send("mark_as_#{new_status.to_s}!")
    TransferMailer.send("#{new_status}_transfer", transfer).deliver_now
    true
  end
end