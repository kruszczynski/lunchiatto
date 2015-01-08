CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Layout = Marionette.LayoutView.extend
    template: 'dashboard/layout'

    ui:
      dishesList: '.dishes-list'
      orderSummary: '.order-summary'

    regions:
      dishesList: '@ui.dishesList'
      orderSummary: '@ui.orderSummary'

    onShow: ->
      @_showSummary()

    _showSummary: ->
      return if @model.get('noOrder')
      summary = new Dashboard.OrderSummary model: @model
      @orderSummary.show summary

    _showDishesList: ->
      return if @model.get('noOrder')
      list = new Dashboard.DishesList collection: @model.get('dishes')
      @dishesList.show list
