module UserAuthorize
  class AddAuthData
    include Interactor

    def call
      return unless context.user.nil? && omniauth_params.info.email.split('@')[1].in?(User::ACCEPTABLE_EMAILS)
      user = User.find_by(email: omniauth_params.info.email)
      return unless user
      user.update(user_params)
      context.user = user
    end

    def omniauth_params
      context.omniauth_params
    end

    def user_params
      {
        provider: omniauth_params.provider,
        uid: omniauth_params.uid,
        name: omniauth_params.info.name
      }
    end
  end
end