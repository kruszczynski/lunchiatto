@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.Controller =
    form: (order) ->
      orderForm = new Order.Form model: order
      App.content.show orderForm

    list: (orders) ->
      ordersList = new Order.List collection: orders
      App.content.show ordersList

    show: (order) ->
      orderView = new App.Order.Show model: order
      App.content.show orderView