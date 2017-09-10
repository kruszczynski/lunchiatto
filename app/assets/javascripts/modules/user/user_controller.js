window.Lunchiatto.module('User', (User, App, Backbone, Marionette, $, _) =>
  User.Controller = {
    members() {
      const membersView = new User.ManageMembers();
      App.root.content.show(membersView);
    },

    show(invitation) {
      const invitationView = new User.ShowInvitation({model: invitation});
      App.root.content.show(invitationView);
    }
  }
);
