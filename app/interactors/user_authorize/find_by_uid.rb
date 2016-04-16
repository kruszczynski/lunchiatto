# frozen_string_literal: true
module UserAuthorize
  # Finds user from provider's uid
  class FindByUid
    include Interactor

    def call
      user_params = context.omniauth_params.slice(:provider, :uid).to_h
      context.user = User.find_by(user_params)
    end
  end
end
