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

    initialize: ->
      @listenTo @model.get('dishes'), 'add remove', @_hideOrderButton
      @model.on 'change', @render, this

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
      @ui.orderButton.toggle(!@model.currentUserOrdered())
