window.Lunchiatto.module('Dashboard', function(Dashboard, App, Backbone, Marionette, $, _) {
  Dashboard.Settings = Marionette.ItemView.extend({
    template: 'dashboard/settings',

    ui: {
      accountNumber: '.account-number'
    },

    behaviors: {
      Submittable: {},
      Animateable: {
        types: ['fadeIn']
      },
      Titleable: {}
    },

    onFormSubmit() {
      this.model.save({
        account_number: this.ui.accountNumber.val()
      }, {
        success(model) {
          App.router.navigate('/orders/today', {trigger: true});
        }
      });
    },

    _htmlTitle() {
      return 'Settings';
    }
  });
});
