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
      @_show("balances")
      @_show("debts")

    _show: (type) ->
      collection = new App.Entities.Balances
        type: type
      collection.fetch
        success: (collection) =>
          view = new Balance.Balances
            collection: collection
          @[type].show view