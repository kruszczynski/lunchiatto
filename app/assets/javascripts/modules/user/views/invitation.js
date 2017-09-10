window.Lunchiatto.module('User', function(User, App, Backbone, Marionette, $, _) {
  User.Invitation = Marionette.ItemView.extend({
    DELETE_MESSAGE: 'Are you sure?',

    template: 'users/invitation',

    behaviors: {
      Animateable: {
        types: ['fadeIn']
      }
    },

    ui: {
      deleteButton: '.delete-invitation'
    },

    triggers: {
      'click @ui.deleteButton': 'delete:invitation'
    },

    onDeleteInvitation() {
      if (confirm(this.DELETE_MESSAGE)) {
        this.$el.addClass('animate__fade-out');
        setTimeout(() => {
          this.model.destroy();
        }
        , App.animationDurationMedium);
      }
    }
  });
});
