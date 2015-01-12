@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.Controller =
    form: (order) ->
      orderForm = new Order.Form model: order
      App.content.show orderForm