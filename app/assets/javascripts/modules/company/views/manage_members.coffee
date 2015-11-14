@Lunchiatto.module "Company", (Company, App, Backbone, Marionette, $, _) ->
  Company.ManageMembers = Marionette.LayoutView.extend
    template: "companies/manage_members"

    ui:
      members: ".members"
      invitations: ".invitations"
      inviteNew: ".invitation-form"

    regions:
      members: "@ui.members"
      invitations: "@ui.invitations"
      inviteNew: "@ui.inviteNew"

    behaviors:
      Animateable:
        types: ["fadeIn"]
      Titleable: {}

    onRender: ->
      @_showMembers()
      @_showInvitations()
      @_showForm()

    _showMembers: ->
      members = @model.get('users')
      membersView = new Company.Members collection: members
      @members.show membersView

    _showInvitations: ->
      invitations = @model.get("invitations")
      invitationsView = new Company.Invitations collection: invitations
      @invitations.show invitationsView

    _showForm: ->
      invitationForm = new Company.InvitationForm
        invitations: @model.get("invitations")
      @inviteNew.show invitationForm

    _htmlTitle: ->
      "#{@model.get('name')} Members"
