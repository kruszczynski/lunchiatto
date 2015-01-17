@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.List = Marionette.CompositeView.extend
    template: 'orders/list'
    childViewContainer: 'tbody'
    getChildView: ->
      Order.Item
