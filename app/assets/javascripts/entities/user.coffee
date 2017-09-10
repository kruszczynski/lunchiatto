@Lunchiatto.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  Entities.User = Backbone.Model.extend
    urlRoot: ->
      '/api/users'

    loggedIn: ->
      !isNaN(@get('id'))

  Entities.Users = Backbone.Collection.extend
    model: Entities.User

    url: ->
      '/api/users'
