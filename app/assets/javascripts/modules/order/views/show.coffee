@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.Show = Marionette.LayoutView.extend
    template: 'orders/show'

    ui:
      dishesSection: '.dishes-section'
      orderButton: '.order-button'

    regions:
      dishes: '@ui.dishesSection'

    initialize: ->
      @listenTo @model.get('dishes'), 'add remove', @_hideOrderButton

    onShow: ->
      @_showDishes()
      @_hideOrderButton()

    _showDishes: ->
      dishes = new Order.Dishes
        collection: @model.get('dishes')
      @dishes.show dishes

    _hideOrderButton: ->
      @ui.orderButton.toggle(!@model.currentUserOrdered())