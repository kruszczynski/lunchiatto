@CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Account = Marionette.ItemView.extend
    template: 'dashboard/account'
    className: 'user-box'
