@Lunchiatto.module 'Company', (Company, App, Backbone, Marionette, $, _) ->

  Company.ManageMembers = Marionette.LayoutView.extend
    template: 'companies/manage_members'

    ui:
      members: '.members'
      invitations: '.invitations'
      inviteNew: '.invitation-form'

    regions:
      members: '@ui.members'
      invitations: '@ui.invitations'
      inviteNew: '@ui.inviteNew'

    behaviors:
      Animateable:
        types: ['fadeIn']
      Titleable: {}

    initialize: ->
      @membersCollection = new App.Entities.Users()
      @invitationsCollection = new App.Entities.Invitations()

    onRender: ->
      @_showMembers()
      @_showInvitations()
      @_showForm()

    _showMembers: ->
      @membersCollection.fetch success: =>
        membersView = new Company.Members(collection: @membersCollection)
        @members.show(membersView)

    _showInvitations: ->
      @invitationsCollection.fetch success: =>
        invitationsView = new Company.Invitations(
          collection: @invitationsCollection)
        @invitations.show(invitationsView)

    _showForm: ->
      invitationForm = new Company.InvitationForm(
        invitations: @invitationsCollection)
      @inviteNew.show(invitationForm)

    _htmlTitle: ->
      'Members'
