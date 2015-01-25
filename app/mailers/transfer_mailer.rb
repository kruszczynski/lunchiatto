class TransferMailer < ApplicationMailer
  default from: "noreply@codequest-manager.herokuapp.com"
  layout "mailer"

  def created_transfer(transfer)
    @transfer = transfer
    @from = transfer.from
    @to = transfer.to
    mail(to: @to.email, subject: "#{@from} has send you a transfer of #{@transfer.amount} PLN")
  end
end