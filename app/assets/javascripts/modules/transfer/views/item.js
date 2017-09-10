window.Lunchiatto.module('Transfer', function(Transfer, App, Backbone, Marionette, $, _) {
  return Transfer.Item = Marionette.ItemView.extend({
    REJECT_MESSAGE: 'The transfer will be rejected! Are you sure?',
    ACCEPT_MESSAGE: 'Are you sure?',
    template: 'transfers/item',
    tagName: 'div',
    className: 'transfer-box',
    templateHelpers() {
      return {type: this.type};
    },

    ui: {
      acceptButton: '.accept-transfer',
      rejectButton: '.reject-transfer'
    },

    modelEvents: {
      'change': '_reload'
    },

    triggers: {
      'click @ui.acceptButton': 'accept:transfer',
      'click @ui.rejectButton': 'reject:transfer'
    },

    initialize(options) {
      this.type = options.type;
    },

    onRejectTransfer() {
      this._hideButtons();
      this.model.reject();
    },

    onAcceptTransfer() {
      this._hideButtons();
      this.model.accept();
    },

    _hideButtons() {
      this.ui.rejectButton.hide();
      this.ui.acceptButton.hide();
    },

    _reload() {
      this.render();
      App.vent.trigger('reload:current:user');
      App.vent.trigger('reload:finances');
    }
  });
});
