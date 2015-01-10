@CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Layout = Marionette.LayoutView.extend
    template: 'dashboard/layout'

    ui:
      orderShow: '.order-show'
      orderSummary: '.order-summary'

    regions:
      orderShow: '@ui.orderShow'
      orderSummary: '@ui.orderSummary'

    onShow: ->
      @_showSummary()
      @_showOrder()

    _showSummary: ->
      return if @model.get('noOrder')
      summary = new Dashboard.OrderSummary model: @model
      @orderSummary.show summary

    _showOrder: ->
      return if @model.get('noOrder')
      order = new App.Order.Show model: @model
      @orderShow.show order
