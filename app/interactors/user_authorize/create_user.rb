# frozen_string_literal: true
module UserAuthorize
  # Does user creation's heavy lifting
  class CreateUser
    include Interactor

    delegate :omniauth_params, :invitation, to: :context
    delegate :info, to: :omniauth_params

    def call
      return if context.user.present?
      context.fail! if info.email != invitation.email
      create_user
    end

    def create_user
      user = User.new(user_params)
      user.save!
      context.user = user
    end

    def user_params
      {
        provider: omniauth_params.provider,
        uid: omniauth_params.uid,
        name: info.name,
        email: info.email,
        company: invitation.company,
      }
    end
  end
end
