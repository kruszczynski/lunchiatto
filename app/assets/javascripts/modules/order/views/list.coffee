@Lunchiatto.module "Order", (Order, App, Backbone, Marionette, $, _) ->
  Order.List = Marionette.CompositeView.extend
    template: "orders/list"
    childViewContainer: ".past-orders-list"
    getChildView: ->
      Order.Item

    behaviors:
      Pageable: {}
      Animateable:
        types: ["fadeIn"]