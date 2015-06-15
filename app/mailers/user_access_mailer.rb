class UserAccessMailer < ApplicationMailer
  def create_email(email)
    @email = email
    admin_emails = User.admin.pluck(:email)
    mail(to: admin_emails, subject: "#{@email} would like to join CQM") if admin_emails.present?
  end
end