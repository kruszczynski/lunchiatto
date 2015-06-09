@CodequestManager.module 'Today', (Today, App, Backbone, Marionette, $, _) ->
  Today.Controller =
    today: (orderId) ->
      orderId = parseInt(orderId, 10)
      Backbone.ajax
        url: "/api/orders/latest"
        success: (data) =>
          collection = new Backbone.Collection data
          if orderId
            order = collection.get(orderId)
          else if collection.length > 0
            order = collection.first()
          layout = new Today.Layout collection: collection, order: order
          App.root.content.show layout
