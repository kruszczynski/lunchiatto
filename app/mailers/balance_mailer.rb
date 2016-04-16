# frozen_string_literal: true
class BalanceMailer < ApplicationMailer
  def debt_email(user, balances)
    @user = user
    @balances = balances
    mail(to: @user.email, subject: "#{user} you owe people money!")
  end
end
