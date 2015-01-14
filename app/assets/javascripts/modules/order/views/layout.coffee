@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.Layout = Marionette.LayoutView.extend
    template: 'orders/layout'

    ui:
      orderShow: '.order-show'
      orderSummary: '.order-summary'

    regions:
      orderShow: '@ui.orderShow'
      orderSummary: '@ui.orderSummary'

    onRender: ->
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
