@Lunchiatto.module "Order", (Order, App, Backbone, Marionette, $, _) ->
  Order.Dishes = Marionette.CollectionView.extend
    className: "dishes-list"
    tagName: "ul"
    getChildView: ->
      Order.Dish
