# frozen_string_literal: true
module UserAuthorize
  # User auth organizer
  class Organizer
    include Interactor::Organizer

    organize FindByUid,
             FindInvitation,
             CreateUser,
             DeleteInvitation

    def call
      super
    # rubocop:disable Lint/HandleExceptions
    rescue Interactor::Failure
    end
  end
end
