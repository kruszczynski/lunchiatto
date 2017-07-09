# frozen_string_literal: true
class InvitationMailer < ApplicationMailer
  def created(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: 'Join Lunchiatto')
  end
end
