window.Lunchiatto.module('User', function(User, App, Backbone, Marionette, $, _) {
  User.ManageMembers = Marionette.LayoutView.extend({
    template: 'users/manage_members',

    ui: {
      members: '.members',
      invitations: '.invitations',
      inviteNew: '.invitation-form'
    },

    regions: {
      members: '@ui.members',
      invitations: '@ui.invitations',
      inviteNew: '@ui.inviteNew'
    },

    behaviors: {
      Animateable: {
        types: ['fadeIn']
      },
      Titleable: {}
    },

    initialize() {
      this.membersCollection = new App.Entities.Users();
      this.invitationsCollection = new App.Entities.Invitations();
    },

    onRender() {
      this._showMembers();
      this._showInvitations();
      this._showForm();
    },

    _showMembers() {
      this.membersCollection.fetch({
        success: () => {
          const membersView = new User.Members({collection: this.membersCollection});
          this.members.show(membersView);
        }
      });
    },

    _showInvitations() {
      this.invitationsCollection.fetch({
        success: () => {
          const invitationsView = new User.Invitations({
            collection: this.invitationsCollection
          });
          this.invitations.show(invitationsView);
        }
      });
    },

    _showForm() {
      const invitationForm = new User.InvitationForm({
        invitations: this.invitationsCollection
      });
      this.inviteNew.show(invitationForm);
    },

    _htmlTitle() {
      return 'Members';
    }
  });
});
