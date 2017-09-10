window.Lunchiatto.module('Transfer', function(Transfer, App, Backbone, Marionette, $, _) {
  return Transfer.Form = Marionette.ItemView.extend({
    template: 'transfers/form',

    ui: {
      userSelect: '.user-id',
      amountInput: '.amount',
      accountNumber: '.account-number',
      accountNumberSection: '.account-number-section'
    },

    triggers: {
      'change @ui.userSelect': 'user:selected'
    },

    templateHelpers() {
      return {usersForSelect: App.usersWithoutMe()};
    },

    behaviors: {
      Errorable: {
        fields: ['amount', 'to']
      },
      Submittable: {},
      Animateable: {
        types: ['fadeIn']
      },
      Titleable: {},
      Selectable: {}
    },

    onShow() {
      if (this.model.get('to_id')) { this.onUserSelected(); }
    },

    onUserSelected() {
      const userId = this.ui.userSelect.val();
      if (userId) {
        const user = _.find(gon.usersForSelect, user => +user.id === +userId);
        this.ui.accountNumber.text(user.account_number);
      }
      this.ui.accountNumberSection.toggleClass('hide', !userId);
    },

    onFormSubmit() {
      this.model.save({
        to_id: this.ui.userSelect.val(),
        amount: this.ui.amountInput.val().replace(',', '.')
      }
      , {
        success() {
          App.vent.trigger('reload:current:user');
          App.router.navigate('/transfers', {trigger: true});
        }
      }
      );
    },

    _htmlTitle() {
      return 'New Transfer';
    }
  });
});
