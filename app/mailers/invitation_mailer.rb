# New invitation email
class InvitationMailer < ApplicationMailer
  def created(invitation)
    @invitation = invitation
    @company = invitation.company
    mail(to: @invitation.email, subject: "Join #{@company.name} on Lunchiatto")
  end
end
