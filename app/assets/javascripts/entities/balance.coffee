@Lunchiatto.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Balance = Backbone.Model.extend({})

  Entities.Balances = Backbone.Collection.extend
    # TODO(janek): no need to change anything here
    # Backend will send same data as debts and balances for now
    # Later - migrate to only one list
    url: ->
      "/api/user_#{@type}"

    initialize: (models, options) ->
      @type = options.type

    total: ->
      @reduce((memo, balance) ->
        memo + parseFloat(balance.get('balance'))
      , 0).toFixed(2)
