@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.User = Backbone.Model.extend
    urlRoot: ->
      "/users"

  Entities.Users = Backbone.Collection.extend
    model: Entities.User

    url: ->
      "/users"

