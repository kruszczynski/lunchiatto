@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Order = Backbone.Model.extend
    parse: (data) ->
      data.dishes = new Entities.Dishes data.dishes
      data.dishes.order = this
      data
