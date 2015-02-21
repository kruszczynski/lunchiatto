@CodequestManager.module 'Balance', (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Layout = Marionette.LayoutView.extend
    template: 'balances/layout'

    ui:
      balances: '.balances'
      debts: '.debts'

    behaviors:
      Animateable:
        types: ["fadeIn"]

    regions:
      balances: "@ui.balances"
      debts: "@ui.debts"

    onRender: ->
      @_showBalances()
      @_showDebts()

    _showBalances: ->
      balancesCollection = new App.Entities.Balances
      balancesCollection.fetch
        success: (collection) =>
          balancesView = new Balance.Balances collection: collection
          @balances.show balancesView

    _showDebts: ->
      debtsCollection = new App.Entities.Debts
      debtsCollection.fetch
        success: (collection) =>
          debtsView = new Balance.Debts
            collection: collection
          @debts.show debtsView