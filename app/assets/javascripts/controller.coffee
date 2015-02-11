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
      App.Finance.Controller.index()

    accountNumbers: ->
      users = new App.Entities.Users
      users.fetch
        success: (users) ->
          App.Dashboard.Controller.accounts(users)

    settings: ->
      App.currentUser.fetch
        success: (user) ->
          App.Dashboard.Controller.settings(user)

    newTransfer: ->
      transfer = new App.Entities.Transfer(new URI(window.location.href).search(true))
      App.Transfer.Controller.form(transfer)