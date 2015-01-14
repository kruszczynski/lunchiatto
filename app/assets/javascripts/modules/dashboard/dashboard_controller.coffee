@CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Controller =
    layout: ->
      Backbone.ajax
        url: '/orders/latest'
        success: (data) =>
          if data
            model = new App.Entities.Order data, parse: true, returnToDashboard: true
          else
            model = new Backbone.Model {noOrder: true}
          dashboardLayout = new Dashboard.Layout model: model
          App.content.show dashboardLayout
          
    accounts: (users) ->
      accountsView = new Dashboard.Accounts collection: users
      App.content.show accountsView

    settings: (user) ->
      settingsView = new Dashboard.Settings model: user
      App.content.show settingsView