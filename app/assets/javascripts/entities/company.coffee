@Lunchiatto.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Company = Backbone.Model.extend
    urlRoot: ->
      '/api/companies'

    parse: (data) ->
      data.users = new Entities.Users(data.users)
      data.invitations = new Entities.Invitations(data.invitations)
      data
