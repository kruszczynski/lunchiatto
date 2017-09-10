window.Lunchiatto.module('User', (User, App, Backbone, Marionette, $, _) =>
  User.Members = Marionette.CompositeView.extend({
    template: 'users/members',

    getChildView() {
      return User.Member;
    },

    childViewContainer: '@ui.membersList',

    className: 'users-list',

    ui: {
      membersList: '.members-list'
    }
  })
);
