@CodequestManager.module "Balance", (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Balances = Marionette.CompositeView.extend
    template: "balances/balances"
    getChildView: ->
      Balance.Balance
    childViewContainer: "tbody"

    templateHelpers: () ->
      totalBalance: @collection.totalBalance()

    collectionEvents:
      "sync": "render"

    initialize: ->
      App.vent.on "reload:finances", =>
        @collection.fetch()