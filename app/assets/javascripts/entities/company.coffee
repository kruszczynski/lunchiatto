@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Company = Backbone.Model.extend
    urlRoot: ->
      "/companies"

    parse: (data) ->
      data.users = new Entities.Users data.users
      data
