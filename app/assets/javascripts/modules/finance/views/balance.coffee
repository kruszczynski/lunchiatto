@CodequestManager.module 'Finance', (Finance, App, Backbone, Marionette, $, _) ->
  Finance.Balance = Marionette.ItemView.extend
    tagName: 'tr'
    template: 'finances/balance'

