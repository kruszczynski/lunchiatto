@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Debt = Backbone.Model.extend {}

  Entities.Debts = Backbone.Collection.extend
    url: '/user_debts'

    totalDebt: ->
      @reduce((memo, debt) ->
        memo + parseFloat(debt.get('balance'))
      ,0).toFixed(2)