do (App = @CodequestManager) ->
  App.Controller =
    dashboard: ->
      App.Dashboard.Controller.layout()

    editDish: (orderId, dishId) ->
      dish = new App.Entities.Dish order_id: orderId, id: dishId
      dish.fetch
        success: (dish) ->
          App.Dish.Controller.form(dish)

    newDish: (orderId) ->
      dish = new App.Entities.Dish order_id: orderId, user_id: App.currentUser.id, price: '0.00'
      App.Dish.Controller.form(dish)

    newOrder: ->
      order = new App.Entities.Order
      App.Order.Controller.form(order)

    showOrder: (orderId) ->
      order = new App.Entities.Order id: orderId
      order.fetch
        success: (order) ->
          App.Order.Controller.show(order)

    editOrder: (orderId) ->
      order = new App.Entities.Order id: orderId
      order.fetch
        success: (order) ->
          App.Order.Controller.form(order)

    ordersIndex: ->
      orders = new App.Entities.Orders
      orders.fetch
        success: (orders) ->
          App.Order.Controller.list(orders)

    finances: ->
      console.log 'finances'