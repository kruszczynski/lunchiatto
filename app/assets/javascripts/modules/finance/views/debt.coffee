@CodequestManager.module 'Finance', (Finance, App, Backbone, Marionette, $, _) ->
  Finance.Debt = Marionette.ItemView.extend
    tagName: 'tr'
    template: 'finances/debt'