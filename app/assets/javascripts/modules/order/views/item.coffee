@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.Item = Marionette.ItemView.extend
    template: 'orders/item'
    tagName: 'li'
    className: 'hover-pointer'

    triggers:
      'click': 'show:order'

#    onShow: ->
#      @$el.removeClass('hide')

    onShowOrder: ->
      App.router.navigate "/orders/#{@model.id}", {trigger: true}