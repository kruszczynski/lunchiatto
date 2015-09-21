@Lunchiatto.module "Today", (Today, App, Backbone, Marionette, $, _) ->
  Today.OrderButtons = Marionette.CompositeView.extend
    template: 'today/order_buttons'
    childViewContainer: '.buttons-container'

    getChildView: ->
      Today.OrderButton

    currentOrder: (orderId) ->
      @children.each (child) ->
        child.toggleActive(child.model.id == orderId)
