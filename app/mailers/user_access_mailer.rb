# frozen_string_literal: true
class UserAccessMailer < ApplicationMailer
  def create_email(email)
    @email = email
    admin_emails = User.admin.pluck(:email)
    return if admin_emails.blank?
    mail(to: admin_emails, subject: "#{@email} would like to join CQM")
  end
end
