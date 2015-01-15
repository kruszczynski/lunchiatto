@CodequestManager.module 'Finance', (Finance, App, Backbone, Marionette, $, _) ->
  Finance.Balances = Marionette.CompositeView.extend
    template: 'finances/balances'
    getChildView: ->
      Finance.Balance
    childViewContainer: "tbody"