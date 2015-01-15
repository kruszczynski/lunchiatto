@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Balance = Backbone.Model.extend {}

  Entities.Balances = Backbone.Collection.extend
  	url: '/user_balances'