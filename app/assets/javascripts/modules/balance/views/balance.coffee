@CodequestManager.module "Balance", (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Balance = Marionette.ItemView.extend
    className: "balance-box"
    template: "balances/balance"

    templateHelpers: ->
      type: @model.collection.type