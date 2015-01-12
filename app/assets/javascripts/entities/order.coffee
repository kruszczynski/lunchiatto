@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Order = Backbone.Model.extend

    urlRoot: ->
      "/orders"

    parse: (data) ->
      data.dishes = new Entities.Dishes data.dishes
      data.dishes.order = this
      data

    currentUserOrdered: ->
      @get('dishes').where(user_id: App.currentUser.id).length isnt 0