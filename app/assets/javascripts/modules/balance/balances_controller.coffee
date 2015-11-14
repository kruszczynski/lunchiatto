@Lunchiatto.module "Balance", (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Controller =
    you: ->
      App.root.content.show @_createView('balances')

    others: ->
      App.root.content.show @_createView('debts')

    _createView: (type) ->
      new Balance.Balances
        collection: new App.Entities.Balances [], type: type
