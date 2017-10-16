window.Lunchiatto.module('Transfer', function(Transfer, App, Backbone, Marionette, $, _) {
  return Transfer.Layout = Marionette.LayoutView.extend({
    template: 'transfers/layout',

    ui: {
      receivedTransfers: '.received-transfers',
      submittedTransfers: '.submitted-transfers'
    },

    behaviors: {
      Animateable: {
        types: ['fadeIn']
      },
      Titleable: {}
    },

    regions: {
      receivedTransfers: '@ui.receivedTransfers',
      submittedTransfers: '@ui.submittedTransfers'
    },

    onRender() {
      this._showTransfers('received');
      this._showTransfers('submitted');
    },

    _showTransfers(type) {
      const transfers = new App.Entities.Transfers([], {type});
      transfers.optionedFetch({
        success: transfers => {
          App.getUsers().then(() => {
            const view = new App.Transfer.List({
              collection: transfers});
            this[`${type}Transfers`].show(view);
          });
        }
      });
    },

    _htmlTitle() {
      return 'Transfers';
    }
  });
});
