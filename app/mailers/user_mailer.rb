class UserMailer < ApplicationMailer
  default from: 'bartek@codequest.com'
  layout false

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to My Codequest Manager')
  end
end
