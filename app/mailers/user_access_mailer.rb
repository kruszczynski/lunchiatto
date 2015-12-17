class UserAccessMailer < ApplicationMailer
  def create_email(email)
    @email = email
    admin_emails = User.admin.pluck(:email)
    # rubocop:disable Style/GuardClause
    if admin_emails.present?
      mail(to: admin_emails, subject: "#{@email} would like to join CQM")
    end
  end
end
