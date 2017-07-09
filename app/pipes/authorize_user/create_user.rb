# frozen_string_literal: true
module AuthorizeUser
  class EmailMismatch < StandardError; end

  # Does user creation's heavy lifting
  class CreateUser < Pipes::Pipe
    require_context :omniauth_params, :invitation
    provide_context :user

    delegate :info, to: :omniauth_params

    def call
      fail EmailMismatch if info.email != invitation.email
      create_user
    end

    private

    def create_user
      user = User.new(user_params)
      user.save!
      add(user: user)
    end

    def user_params
      {
        provider: omniauth_params.provider,
        uid: omniauth_params.uid,
        name: info.name,
        email: info.email,
      }
    end
  end
end
