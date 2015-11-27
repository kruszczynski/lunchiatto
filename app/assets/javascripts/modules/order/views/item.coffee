@Lunchiatto.module "Order", (Order, App, Backbone, Marionette, $, _) ->
  Order.Item = Marionette.ItemView.extend
    template: "orders/item"
    tagName: "li"
    className: "hover-pointer"

    triggers:
      "click": "show:order"

    behaviors:
      Animateable:
        types: ["fadeIn"]

    templateHelpers: ->
      machineStatus: @model.get('status').replace('_','-')
      humanStatus: @model.get('status').replace('_', ' ')

    onShowOrder: ->
      App.router.navigate "/orders/#{@model.id}", {trigger: true}
