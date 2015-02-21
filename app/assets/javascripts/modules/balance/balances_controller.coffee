@CodequestManager.module "Balance", (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Controller =
    index: ->
      layout = new Balance.Layout
      App.root.content.show layout