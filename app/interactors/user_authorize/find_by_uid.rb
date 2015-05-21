module UserAuthorize
  class FindByUid
    include Interactor

    def call
      context.user = User.find_by(context.omniauth_params.slice(:provider, :uid).to_h)
    end
  end
end