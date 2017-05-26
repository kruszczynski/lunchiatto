@Lunchiatto.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Balance = Backbone.Model.extend({})

  Entities.Balances = Backbone.Collection.extend
    url: ->
      '/api/user_balances'

    total: ->
      @reduce((memo, balance) ->
        memo + parseFloat(balance.get('balance'))
      , 0).toFixed(2)
