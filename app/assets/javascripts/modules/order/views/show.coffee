@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.Show = Marionette.LayoutView.extend
    template: 'orders/show'

    ui:
      dishesSection: '.dishes-section'

    regions:
      dishes: '@ui.dishesSection'

    initialize: ->
      @model.on 'all', (e) ->
        console.log e

    onShow: ->
      @_showDishes()

    _showDishes: ->
      dishes = new Order.Dishes
        collection: @model.get('dishes')
      @dishes.show dishes