module UserAuthorize
  class Organizer

    include Interactor::Organizer

    organize FindByUid,
             AddAuthData

  end
end
