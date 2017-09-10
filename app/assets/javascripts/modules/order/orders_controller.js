window.Lunchiatto.module('Order', (Order, App, Backbone, Marionette, $, _) =>
  Order.Controller = {
    form(order) {
      const orderForm = new Order.Form({model: order});
      App.root.content.show(orderForm);
    },

    list(orders) {
      const ordersList = new Order.List({collection: orders});
      App.root.content.show(ordersList);
    },

    show(order) {
      const orderView = new App.Order.Show({model: order});
      App.root.content.show(orderView);
    }
  }
);
