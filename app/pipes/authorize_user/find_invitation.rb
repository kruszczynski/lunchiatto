# frozen_string_literal: true
module AuthorizeUser
  # finds user's invitation
  class FindInvitation < Pipes::Pipe
    require_context :omniauth_params
    provide_context :invitation

    def call
      add(invitation: find_invitation)
    end

    private

    def find_invitation
      Invitation.find_by!(email: omniauth_params.info.email)
    end
  end # class FindInvitation
end # module AuthorizeUser
