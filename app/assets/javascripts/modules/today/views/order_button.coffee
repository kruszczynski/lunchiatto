@CodequestManager.module "Today", (Today, App, Backbone, Marionette, $, _) ->
  Today.OrderButton = Marionette.ItemView.extend
    template: 'today/order_button'
    tagName: 'span'

    ui:
      button: '.button'

    triggers:
      'click @ui.button': 'select:order'
