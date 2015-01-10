@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.Dishes = Marionette.CompositeView.extend
    template: 'orders/dishes'

    childViewContainer: 'tbody'

    initialize: ->
      @model = @collection.order

    getChildView: ->
      Order.Dish
