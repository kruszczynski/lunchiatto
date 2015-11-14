@Lunchiatto.module "Balance", (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Balance = Marionette.ItemView.extend
    className: "balance-box"
    template: "balances/balance"

    balancesUserKey: 'payer'
    debtsUserKey: 'user'

    templateHelpers: ->
      formattedBalance: @formattedBalance()
      amountClass: @amountClass()
      transferLink: @transferLink()
      adequateUser: @_adequateUser()

    amountClass: ->
      return unless @model.get('balance')
      modifier = if +@model.get('balance') >= 0 then 'positive' else 'negative'
      "money-box--#{modifier}"

    formattedBalance: ->
      account_balance = @model.get('balance')
      account_balance && "#{account_balance} PLN" || 'N/A'

    transferLink: ->
      return unless @model.collection.type is 'balances'
      "/transfers/new?to_id=#{@_adequateUser()}\
        &amount=#{-@model.get('balance')}"

    _adequateUser: ->
      # calls balancesUserKey, debtsUserKey
      userKey = @["#{@model.collection.type}UserKey"]
      @model.get(userKey)
