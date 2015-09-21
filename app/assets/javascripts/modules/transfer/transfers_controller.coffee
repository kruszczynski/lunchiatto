@Lunchiatto.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Controller =
    form: () ->
      transfer = new App.Entities.Transfer(new URI(window.location.href).search(true))
      form = new Transfer.Form model: transfer
      App.root.content.show form

    index: ->
      layout = new Transfer.Layout
      App.root.content.show layout