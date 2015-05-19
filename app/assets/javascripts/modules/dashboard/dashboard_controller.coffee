@CodequestManager.module "Dashboard", (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Controller =
    accounts: ->
      users = new App.Entities.Users
      users.fetch success: @showAccounts

    showAccounts: (users) ->
      accountsView = new Dashboard.Accounts collection: users
      App.root.content.show accountsView


    settings: (user) ->
      settingsView = new Dashboard.Settings model: user
      App.root.content.show settingsView
