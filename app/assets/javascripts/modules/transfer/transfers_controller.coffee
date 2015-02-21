@CodequestManager.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Controller =
    form: (transfer) ->
      form = new Transfer.Form model: transfer
      App.root.content.show form

    index: ->
      layout = new Transfer.Layout
      App.root.content.show layout