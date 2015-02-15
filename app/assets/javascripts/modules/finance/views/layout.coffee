@CodequestManager.module 'Finance', (Finance, App, Backbone, Marionette, $, _) ->
  Finance.Layout = Marionette.LayoutView.extend
    template: 'finances/layout'

    ui:
      balances: '.balances'
      debts: '.debts'
      receivedTransfers: '.received-transfers'
      submittedTransfers: '.submitted-transfers'

    behaviors:
      Animateable:
        types: ["fadeIn"]

    regions:
      balances: "@ui.balances"
      debts: "@ui.debts"
      receivedTransfers: "@ui.receivedTransfers"
      submittedTransfers: "@ui.submittedTransfers"

    onRender: ->
      @_showBalances()
      @_showDebts()
      @_showTransfers()

    _showBalances: ->
      balancesCollection = new App.Entities.Balances
      balancesCollection.fetch
        success: (collection) =>
          balancesView = new Finance.Balances collection: collection
          @balances.show balancesView

    _showDebts: ->
      debtsCollection = new App.Entities.Debts
      debtsCollection.fetch
        success: (collection) =>
          debtsView = new Finance.Debts 
            collection: collection
          @debts.show debtsView

    _showTransfers: ->
      receivedTransfers = new App.Entities.Transfers [], type: 'received'
      receivedTransfers.optionedFetch
        success: (transfers) =>
          receivedView = new App.Transfer.Table 
            collection: transfers
          @receivedTransfers.show receivedView
      submittedTransfers = new App.Entities.Transfers [], type: 'submitted'
      submittedTransfers.optionedFetch
        success: (transfers) =>
          submittedView = new App.Transfer.Table
            collection: transfers
          @submittedTransfers.show submittedView