@Lunchiatto.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Empty = Marionette.ItemView.extend
    template: "transfers/empty"
    className: "transfer-box__empty"
