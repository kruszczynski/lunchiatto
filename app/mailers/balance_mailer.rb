class BalanceMailer < ApplicationMailer
  default from: 'noreply@codequest-manager.herokuapp.com'
  layout 'mailer'

  def debt_email(user, balances)
    @user = user
    @balances = balances
    mail(to: @user.email, subject: "#{user} you owe people money!")
  end
end
