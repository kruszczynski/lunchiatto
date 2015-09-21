@Lunchiatto.module "Balance", (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Balance = Marionette.ItemView.extend
    className: "balance-box"
    template: "balances/balance"

    templateHelpers: ->
      formattedNumber: @formattedNumber()
      formattedBalance: @formattedBalance()
      amountClass: @amountClass()
      transferLink: @transferLink()
      adequateUser: @model.get(@adequateUser)

    initialize: ->
      @adequateUser = if @model.collection.type is "balances" then 'payer' else 'user'

    amountClass: ->
      return unless @model.get('balance')
      modifier = if +@model.get('balance') >= 0 then "positive" else "negative"
      "money-box--#{modifier}"

    formattedBalance: ->
      account_balance = @model.get('balance')
      if account_balance
        account_balance + " PLN"
      else
        "N/A"

    formattedNumber: ->
      @model.get('account_number') || "Bank Account Number Not Provided"

    transferLink: ->
      return unless @model.collection.type is "balances"
      "/transfers/new?to_id=#{@model.get("#{@adequateUser}_id")}&amount=#{-@model.get('balance')}"
