@CodequestManager.module 'Finance', (Finance, App, Backbone, Marionette, $, _) ->
  Finance.Controller =
    index: (user) ->
      layout = new Finance.Layout model: user
      App.content.show layout