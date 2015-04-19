@CodequestManager.module "Today", (Today, App, Backbone, Marionette, $, _) ->
  Today.OrderButtons = Marionette.CompositeView.extend
    template: 'today/order_buttons'
    childViewContainer: '.buttons-container'

    getChildView: ->
      Today.OrderButton

    childViewOptions: (model) ->
      console.log @options.currentOrderId
      console.log model.id
      current: true if @options.currentOrderId == model.id