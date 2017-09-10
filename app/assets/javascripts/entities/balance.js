window.Lunchiatto.module('Entities', function(Entities, App, Backbone, Marionette, $, _) {
  Entities.Balance = Backbone.Model.extend({});

  Entities.Balances = Backbone.Collection.extend({
    url() {
      return '/api/balances';
    },

    total() {
      return this.reduce((memo, balance) => {
        return memo + parseFloat(balance.get('balance'));
      }, 0).toFixed(2);
    }
  });
});
