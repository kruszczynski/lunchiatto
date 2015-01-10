@CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.OrderSummary = Marionette.ItemView.extend
    template: 'dashboard/order_summary'