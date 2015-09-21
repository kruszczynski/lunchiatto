@Lunchiatto.module "Company", (Company, App, Backbone, Marionette, $, _) ->
  Company.Invitations = Marionette.CompositeView.extend
    template: "companies/invitations"

    getChildView: ->
      Company.Invitation

    getEmptyView: ->
      Company.InvitationEmpty

    childViewContainer: "@ui.invitationsList"

    className: "users-list"

    ui:
      invitationsList: ".invitations-list"
