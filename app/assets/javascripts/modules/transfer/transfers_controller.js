window.Lunchiatto.module('Transfer', (Transfer, App, Backbone, Marionette, $, _) =>
  Transfer.Controller = {
    form() {
      const transfer = new App.Entities.Transfer(
        new URI(window.location.href).search(true));
      const form = new Transfer.Form({model: transfer});
      App.root.content.show(form);
    },

    index() {
      const layout = new Transfer.Layout;
      App.root.content.show(layout);
    }
  }
);
