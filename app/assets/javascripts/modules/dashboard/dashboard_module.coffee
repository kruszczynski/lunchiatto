CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.layout = ->
    dashboardLayout = new Dashboard.Layout
    App.content.show dashboardLayout