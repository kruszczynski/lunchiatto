@CodequestManager.module 'Finance', (Finance, App, Backbone, Marionette, $, _) ->
  Finance.Balances = Marionette.CompositeView.extend
    template: 'finances/balances'
    getChildView: ->
      Finance.Balance
    childViewContainer: "tbody"

    templateHelpers: () ->
      totalBalance: @collection.totalBalance()

    collectionEvents:
      'sync': 'render'

    initialize: ->
      App.vent.on 'reload:finances', =>
        @collection.fetch()