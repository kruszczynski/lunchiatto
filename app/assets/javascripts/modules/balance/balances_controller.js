window.Lunchiatto.module('Balance', (Balance, App, Backbone, Marionette, $, _) =>
  Balance.Controller = {
    you() {
      App.root.content.show(
        new Balance.Balances({collection: new App.Entities.Balances([])})
      );
    }
  }
);
