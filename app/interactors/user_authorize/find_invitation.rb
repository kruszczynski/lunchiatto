module UserAuthorize
  class FindInvitation
    include Interactor

    # Usage def omniauth_params
    delegate :omniauth_params, to: :context

    def call
      return if context.user.present?
      invitation = Invitation.find_by(email: omniauth_params.info.email,
                                      authorized: true)
      context.fail! unless invitation
      context.invitation = invitation
    end
  end
end
