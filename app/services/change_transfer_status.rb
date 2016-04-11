# frozen_string_literal: true
# Changing transfer status require an email
# This object encapsulates that
class ChangeTransferStatus
  attr_reader :transfer, :user
  def initialize(transfer, user)
    @transfer = transfer
    @user = user
  end

  def perform(new_status)
    # calls transfer.mark_as_accepted!
    #       transfer.mark_as_rejected!
    transfer.send("mark_as_#{new_status}!")
    TransferMailer.send("#{new_status}_transfer", transfer).deliver_later
    true
  end
end
