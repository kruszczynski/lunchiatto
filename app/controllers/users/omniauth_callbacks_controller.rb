# frozen_string_literal: true
module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    FLOW = AuthorizeUser::FindInvitation |
           AuthorizeUser::CreateUser |
           Pipes::Closure.define { invitation.destroy }

    # This method smells of :reek:UncommunicativeMethodName
    # google_oauth2 is expected callback action name in this case
    def google_oauth2
      process_invitation unless user
      sign_in_and_redirect(user)
      set_flash_message(:notice, :success, kind: 'Google')
    rescue ActiveRecord::RecordNotFound, AuthorizeUser::EmailMismatch
      redirect_to root_path,
                  alert: 'You must receive an invitation to sign in'
    end

    private

    def process_invitation
      FLOW.call(context)
      @user = context.user
    end

    def context
      @context ||= Pipes::Context.new(omniauth_params: omniauth_params)
    end

    def user
      @user ||= User.find_by(omniauth_params.slice(:provider, :uid).to_h)
    end

    def omniauth_params
      request.env['omniauth.auth']
    end
  end
end
