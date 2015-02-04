class TransferMailer < ApplicationMailer
  def created_transfer(transfer)
    @transfer = transfer
    @from = transfer.from
    @to = transfer.to
    mail(to: @to.email, subject: "#{@from} has send you a transfer of #{@transfer.amount} PLN")
  end

  def pending_transfers(transfers, user)
    @transfers = transfers
    @user = user
    mail(to: @user.email, subject: "You have pending transfers!")
  end

  def accepted_transfer(transfer)
    @transfer = transfer
    @from = transfer.from
    @to = transfer.to
    mail(to: @from.email, subject: "#{@to} has accepted your transfer of #{@transfer.amount} PLN")
  end

  def rejected_transfer(transfer)
    @transfer = transfer
    @from = transfer.from
    @to = transfer.to
    mail(to: @from.email, subject: "#{@to} has rejected your transfer of #{@transfer.amount} PLN")
  end
end