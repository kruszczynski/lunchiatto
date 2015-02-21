@CodequestManager.module "Balance", (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Debts = Marionette.CompositeView.extend
    template: "balances/debts"
    getChildView: ->
      Balance.Debt
    childViewContainer: "tbody"

    templateHelpers: () ->
      totalDebt: @collection.totalDebt()

    collectionEvents:
      "sync": "render"

    initialize: ->
      App.vent.on "reload:finances", =>
        @collection.fetch()      