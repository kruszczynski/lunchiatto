module UserAuthorize
  class FindInvitation
    include Interactor

    def call
      return if context.user.present?
      invitation = Invitation.find_by(email: omniauth_params.info.email,
                                      authorized: true)
      context.fail! unless invitation
      context.invitation = invitation
    end

    def omniauth_params
      context.omniauth_params
    end
  end
end
