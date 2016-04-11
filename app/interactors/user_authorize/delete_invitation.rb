# frozen_string_literal: true
module UserAuthorize
  # Removes realized invitation
  class DeleteInvitation
    include Interactor

    delegate :invitation, to: :context

    def call
      return unless invitation.present?
      invitation.delete
    end
  end
end
