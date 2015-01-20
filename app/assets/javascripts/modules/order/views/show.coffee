@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.Show = Marionette.LayoutView.extend
    template: 'orders/show'

    ui:
      dishesSection: '.dishes-section'
      orderButton: '.order-button'
      changeStatus: '.change-status-button'

    regions:
      dishes: '@ui.dishesSection'

    triggers:
      'click @ui.changeStatus': 'change:status'

    modelEvents:
      'change': 'render'

    initialize: ->
      @listenTo @model.get('dishes'), 'add remove', @_hideOrderButton

    onRender: ->
      @_showDishes()
      @_hideOrderButton()

    onChangeStatus: ->
      @model.changeStatus()

    _showDishes: ->
      dishes = new Order.Dishes
        collection: @model.get('dishes')
      @dishes.show dishes

    _hideOrderButton: ->
      @ui.orderButton.toggleClass('hide',@model.currentUserOrdered())
