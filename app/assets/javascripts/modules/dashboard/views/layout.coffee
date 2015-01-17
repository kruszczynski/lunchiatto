@CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Layout = Marionette.LayoutView.extend
    template: 'dashboard/layout'

    ui:
      orderShow: '.order-show'

    regions:
      orderShow: '@ui.orderShow'
