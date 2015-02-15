@CodequestManager.module "Order", (Order, App, Backbone, Marionette, $, _) ->
  Order.Show = Marionette.LayoutView.extend
    template: "orders/show"

    ui:
      dishesSection: ".dishes-section"
      orderButton: ".order-button"
      changeStatus: ".change-status-button"
      orderTotal: ".title-total"

    regions:
      dishes: "@ui.dishesSection"

    triggers:
      "click @ui.changeStatus": "change:status"

    behaviors:
      Animateable:
        type: 'fadeIn'

    modelEvents:
      "change": "render"

    initialize: ->
      @listenTo @model.get("dishes"), "add remove", @_hideOrderButton
      @listenTo @model.get("dishes"), "add remove", @_recalculateTotal

    onRender: ->
      @_showDishes()
      @_hideOrderButton()

    onChangeStatus: ->
      @model.changeStatus()

    _showDishes: ->
      dishes = new Order.Dishes
        collection: @model.get("dishes")
      @dishes.show dishes

    _hideOrderButton: ->
      @ui.orderButton.toggleClass("hide",@model.currentUserOrdered())

    _recalculateTotal: ->
      @ui.orderTotal.text @model.total()
