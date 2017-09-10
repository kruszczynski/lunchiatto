window.Lunchiatto.module('User', (User, App, Backbone, Marionette, $, _) =>
  User.InvitationEmpty = Marionette.ItemView.extend({
    template: 'users/invitation_empty'
  })
);
