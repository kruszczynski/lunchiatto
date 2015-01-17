@CodequestManager.module 'Finance', (Finance, App, Backbone, Marionette, $, _) ->
  Finance.Balances = Marionette.CompositeView.extend
    template: 'finances/balances'
    getChildView: ->
      Finance.Balance
    childViewContainer: "tbody"

    templateHelpers: () ->
      totalBalance: @collection.totalBalance()

    initialize: ->
      @collection.on 'sync', @render, this
      App.vent.on 'reload:finances', =>
        @collection.fetch()