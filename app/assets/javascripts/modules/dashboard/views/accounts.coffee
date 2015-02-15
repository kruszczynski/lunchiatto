@CodequestManager.module "Dashboard", (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Accounts = Marionette.CompositeView.extend
    template: "dashboard/accounts"
    getChildView: ->
      Dashboard.Account
    childViewContainer: "tbody"

    behaviors:
      Animateable:
        type: "fadeIn"