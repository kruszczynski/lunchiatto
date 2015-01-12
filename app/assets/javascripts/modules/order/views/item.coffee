@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.Item = Marionette.ItemView.extend
    template: 'orders/item'
    tagName: 'tr'
    className: 'hover-pointer'

    triggers:
      'click': 'show:order'

    onShowOrder: ->
      App.router.navigate "/orders/#{@model.id}", {trigger: true}