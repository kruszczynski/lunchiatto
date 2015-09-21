@Lunchiatto.module "Today", (Today, App, Backbone, Marionette, $, _) ->
  Today.Layout = Marionette.LayoutView.extend
    template: "today/layout"

    regions:
      orderButtons: ".order-buttons"
      order: ".order"

    behaviors:
      Animateable:
        types: ["fadeIn"]

    initialize: (options) ->
      @currentOrder = options.order

    onRender: ->
      @_showButtons()
      if @currentOrder
        @showOrder(@currentOrder)
      else
        @_navigateToToday()

    showOrder: (order) ->
      App.router.navigate "/orders/today/#{order.id}"
      order = new App.Entities.Order id: order.id
      order.fetch
        success: (order) =>
          @buttons.currentOrder(order.id)
          view = new App.Order.Show model: order
          @order.show view

    _showButtons: ->
      @buttons = new Today.OrderButtons collection: @collection
      @buttons.on 'childview:select:order', (orderView) => @showOrder(orderView.model)
      @orderButtons.show @buttons

    _navigateToToday: ->
      App.router.navigate "/orders/today"