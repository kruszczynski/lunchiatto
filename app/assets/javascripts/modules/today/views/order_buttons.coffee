@CodequestManager.module "Today", (Today, App, Backbone, Marionette, $, _) ->
  Today.OrderButtons = Marionette.CompositeView.extend
    template: 'today/order_buttons'

    getChildView: ->
      Today.OrderButton
    childViewContainer: '.buttons-container'