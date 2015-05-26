module UserAuthorize
  class DeleteInvitation
    include Interactor

    def call
      return unless context.invitation.present?
      context.invitation.delete
    end
  end
end