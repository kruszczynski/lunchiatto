module UserAuthorize
  class CreateUser
    include Interactor

    def call
      return if context.user.present?
      context.fail! if omniauth_params.info.email != invitation.email
      create_user
    end

    def create_user
      user = User.new(user_params)
      user.save!
      context.user = user
    end

    def omniauth_params
      context.omniauth_params
    end

    def invitation
      context.invitation
    end

    def user_params
      {
        provider: omniauth_params.provider,
        uid: omniauth_params.uid,
        name: omniauth_params.info.name,
        email: omniauth_params.info.email,
        company: invitation.company,
      }
    end
  end
end
