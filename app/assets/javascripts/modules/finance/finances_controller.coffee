@CodequestManager.module 'Finance', (Finance, App, Backbone, Marionette, $, _) ->
  Finance.Controller =
    index: ->
      layout = new Finance.Layout
      App.root.content.show layout