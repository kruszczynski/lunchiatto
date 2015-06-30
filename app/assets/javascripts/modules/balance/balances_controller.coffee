@CodequestManager.module "Balance", (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Controller =
    you: ->
      balances = new Balance.Balances type: "balances"
      App.root.content.show balances

    others: ->
      balances = new Balance.Balances type: "debts"
      App.root.content.show balances
