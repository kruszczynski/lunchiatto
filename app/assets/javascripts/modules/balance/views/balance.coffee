@CodequestManager.module "Balance", (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Balance = Marionette.ItemView.extend
    tagName: "tr"
    template: "balances/balance"

