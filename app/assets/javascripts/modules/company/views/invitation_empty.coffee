@Lunchiatto.module "Company", (Company, App, Backbone, Marionette, $, _) ->
  Company.InvitationEmpty = Marionette.ItemView.extend
    template: "companies/invitation_empty"