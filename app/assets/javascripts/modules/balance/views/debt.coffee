@CodequestManager.module "Balance", (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Debt = Marionette.ItemView.extend
    tagName: "tr"
    template: "balances/debt"
