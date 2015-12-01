module UserAuthorize
  # finds user's invitation
  class FindInvitation
    include Interactor

    # Usage def omniauth_params
    delegate :omniauth_params, to: :context

    def call
      return if context.user.present?
      invitation = find_invitation
      context.fail! unless invitation
      context.invitation = invitation
    end

    private

    def find_invitation
      Invitation.find_by(email: omniauth_params.info.email,
                         authorized: true)
    end
  end
end
