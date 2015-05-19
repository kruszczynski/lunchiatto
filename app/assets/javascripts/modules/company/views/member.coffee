@CodequestManager.module "Company", (Company, App, Backbone, Marionette, $, _) ->
  Company.Member = Marionette.ItemView.extend
    template: "companies/member"
