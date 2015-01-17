@CodequestManager.module 'Finance', (Finance, App, Backbone, Marionette, $, _) ->
  Finance.Debts = Marionette.CompositeView.extend
    template: 'finances/debts'
    getChildView: ->
      Finance.Debt
    childViewContainer: "tbody"

    templateHelpers: () ->
      totalDebt: @collection.totalDebt()

    initialize: ->
      @collection.on 'sync', @render, this
      App.vent.on 'reload:finances', =>
        @collection.fetch()      