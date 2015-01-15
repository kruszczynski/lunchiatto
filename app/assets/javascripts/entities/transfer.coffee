@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Transfer = Backbone.Model.extend {}

  Entities.Transfers = Backbone.Collection.extend
    model: Entities.Transfer
    url: ->
      "/#{@type}_transfers"

    initialize: (models, options)->
      @type = options.type
