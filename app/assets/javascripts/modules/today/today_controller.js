window.Lunchiatto.module('Today', (Today, App, Backbone, Marionette, $, _) =>
  Today.Controller = {
    today(orderId) {
      orderId = parseInt(orderId, 10);
      Backbone.ajax({
        url: '/api/orders/latest',
        success(data) {
          const collection = new Backbone.Collection(data);
          var order = collection.get(orderId) || (order = collection.first());
          const layout = new Today.Layout({collection, order});
          App.root.content.show(layout);
        }
      });
    }
  }
);
