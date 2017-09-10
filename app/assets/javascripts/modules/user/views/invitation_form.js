window.Lunchiatto.module('User', function(User, App, Backbone, Marionette, $, _) {
  User.InvitationForm = Marionette.ItemView.extend({
    template: 'users/invitation_form',

    ui: {
      emailInput: '.email'
    },

    behaviors: {
      Errorable: {
        fields: ['email']
      },
      Submittable: {}
    },

    initialize(options) {
      this.invitations = options.invitations;
      this.model = new App.Entities.Invitation;
    },

    onFormSubmit() {
      this.model.save({
        email: this.ui.emailInput.val()
      }, {
        success: model => this.saveSuccess(model)
      });
    },

    saveSuccess(model) {
      this.invitations.add(model.clone());
      this.model.set({email: null, id: null});
      this.ui.emailInput.val('');
    }
  });
});
