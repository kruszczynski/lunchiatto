@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.List = Marionette.CompositeView.extend
    template: 'orders/list'
    childViewContainer: '.past-orders-list'
    className: 'animate__fade-in'
    getChildView: ->
      Order.Item

    behaviors:
      Pageable: {}
