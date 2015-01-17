@CodequestManager.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Controller =
    form: (transfer) ->
      form = new Transfer.Form model: transfer
      App.content.show form