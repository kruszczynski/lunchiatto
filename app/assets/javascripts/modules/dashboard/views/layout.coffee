@CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Layout = Marionette.ItemView.extend
    template: 'dashboard/layout'
    className: 'order-wrapper'