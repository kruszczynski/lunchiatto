class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    organizer = UserAuthorize::Organizer.new omniauth_params: omniauth_params
    organizer.call
    @user = organizer.context.user
    if @user
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Google')
    else
      redirect_to root_path, alert: 'You must receive an invitation to sign in'
    end
  end

  private

  def omniauth_params
    request.env['omniauth.auth']
  end
end
