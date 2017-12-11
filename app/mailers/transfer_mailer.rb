# frozen_string_literal: true
class TransferMailer < ApplicationMailer
  def created_transfer(transfer)
    @transfer = transfer
    mail(to: @transfer.to.email,
         subject: "#{@transfer.from} has "\
                  "send you a transfer of #{@transfer.amount} PLN")
  end

  def pending_transfers(transfers, user)
    @transfers = transfers
    @user = user
    mail(to: @user.email, subject: 'You have pending transfers!')
  end

  def accepted_transfer(transfer)
    status_email(transfer, 'accepted')
  end

  def rejected_transfer(transfer)
    status_email(transfer, 'rejected')
  end

  private

  def status_email(transfer, direction)
    @transfer = transfer
    mail(to: @transfer.from.email,
         subject: "#{@transfer.to} has #{direction} your transfer of "\
                  "#{@transfer.amount} PLN")
  end
end
