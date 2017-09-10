window.Lunchiatto.module('Balance', function(Balance, App, Backbone, Marionette, $, _) {
  Balance.Balances = Marionette.CompositeView.extend({
    template: 'balances/balances',
    getChildView() {
      return Balance.Balance;
    },
    childViewContainer: '.balances-container',

    behaviors: {
      Titleable: {}
    },

    templateHelpers() {
      return {
        totalLabel: `Your balance to others ${this.collection.total()}`
      };
    },

    collectionEvents: {
      'sync': 'render'
    },

    initialize() {
      this.collection.fetch();

      App.vent.on('reload:finances', () => {
        this.collection.fetch();
      });
    },

    _htmlTitle() {
      return 'Balances';
    }
  });
});
