module UserAuthorize
  class Organizer
    include Interactor::Organizer

    organize FindByUid,
             FindInvitation,
             CreateUser,
             DeleteInvitation

    def call
      super
    rescue Interactor::Failure
      puts 'User authorization failed'
    end
  end
end
