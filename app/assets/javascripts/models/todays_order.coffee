@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.TodaysOrder = Entities.Order.extend
    url: '/orders/latest.json'
