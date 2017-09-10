window.Lunchiatto.module('User', (User, App, Backbone, Marionette, $, _) =>
  User.Invitations = Marionette.CompositeView.extend({
    template: 'users/invitations',

    getChildView() {
      return User.Invitation;
    },

    getEmptyView() {
      return User.InvitationEmpty;
    },

    childViewContainer: '@ui.invitationsList',

    className: 'users-list',

    ui: {
      invitationsList: '.invitations-list'
    }
  })
);
