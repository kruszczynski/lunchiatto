@CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Account = Marionette.ItemView.extend
    template: 'dashboard/account'
    className: ->
      "user-box #{@amountClass()}"

    templateHelpers: ->
      formattedNumber: @formattedNumber()
      formattedBalance: @formattedBalance()

    amountClass: ->
      return unless @model.get('account_balance')
      modifier = if +@model.get('account_balance') >= 0 then "positive" else "negative"
      "user-box__#{modifier}"

    formattedBalance: ->
      account_balance = @model.get('account_balance')
      if account_balance
        account_balance + " PLN"
      else
        "N/A"

    formattedNumber: ->
      @model.get('account_number') || "Bank Account Number Not Provided"
