# frozen_string_literal: true
module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # This method smells of :reek:UncommunicativeMethodName
    # google_oauth2 is expected callback action name in this case
    def google_oauth2
      run_user_authorize
      if @organizer.context.success? && @user
        sign_in_and_redirect @user
        set_flash_message(:notice, :success, kind: 'Google')
      else
        redirect_to root_path,
                    alert: 'You must receive an invitation to sign in'
      end
    end

    private

    def run_user_authorize
      @organizer = UserAuthorize::Organizer.new omniauth_params: omniauth_params
      @organizer.call
      @user = @organizer.context.user
    end

    def omniauth_params
      request.env['omniauth.auth']
    end
  end
end
