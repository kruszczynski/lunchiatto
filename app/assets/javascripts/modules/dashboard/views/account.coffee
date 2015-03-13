@CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Account = Marionette.ItemView.extend
    template: 'dashboard/account'
    className: ->
      "user-box #{@amountClass()}"

    amountClass: ->
      modifier = if +@model.get('account_balance') > 0 then "positive" else "negative"
      console.log "user-box__amount__#{modifier}"
      "user-box__#{modifier}"
