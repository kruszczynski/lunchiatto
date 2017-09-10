do (App = @Lunchiatto) ->
  forLoggedInOnly = ->
    return false if App.currentUser.loggedIn()
    App.router.navigate('/', {trigger: true})
    true

  maybeRedirectToToday = ->
    return false unless App.currentUser.loggedIn()
    App.router.navigate('/orders/today', {trigger: true})
    true

  App.Controller =
    pageIndex: ->
      return if maybeRedirectToToday()
      App.Page.Controller.index()

    showInvitation: (invitationId) ->
      return if maybeRedirectToToday()
      invitation = new App.Entities.Invitation(id: invitationId)
      invitation.fetch
        success: (invitation) ->
          App.User.Controller.show(invitation)

    ordersToday: (orderId) ->
      return if forLoggedInOnly()
      App.Today.Controller.today(orderId)

    editDish: (orderId, dishId) ->
      return if forLoggedInOnly()
      dish = new App.Entities.Dish(order_id: orderId, id: dishId)
      dish.fetch
        success: (dish) ->
          App.Dish.Controller.form(dish)

    newDish: (orderId) ->
      return if forLoggedInOnly()
      dish = new App.Entities.Dish
        order_id: orderId,
        user_id: App.currentUser.id,
        price: '0.00'
      App.Dish.Controller.form(dish)

    newOrder: ->
      return if forLoggedInOnly()
      order = new App.Entities.Order(shipping: '0.00')
      App.Order.Controller.form(order)

    showOrder: (orderId) ->
      return if forLoggedInOnly()
      order = new App.Entities.Order(id: orderId)
      order.fetch
        success: (order) ->
          App.Order.Controller.show(order)

    editOrder: (orderId) ->
      return if forLoggedInOnly()
      order = new App.Entities.Order(id: orderId)
      order.fetch
        success: (order) ->
          App.Order.Controller.form(order)

    ordersIndex: ->
      return if forLoggedInOnly()
      orders = new App.Entities.Orders
      orders.fetch
        success: (orders) ->
          App.Order.Controller.list(orders)

    yourBalances: ->
      return if forLoggedInOnly()
      App.Balance.Controller.you()

    othersBalances: ->
      return if forLoggedInOnly()
      App.Balance.Controller.others()

    accountNumbers: ->
      return if forLoggedInOnly()
      App.Dashboard.Controller.accounts()

    settings: ->
      return if forLoggedInOnly()
      App.currentUser.fetch
        success: (user) ->
          App.Dashboard.Controller.settings(user)

    transfersIndex: ->
      return if forLoggedInOnly()
      App.Transfer.Controller.index()

    newTransfer: ->
      return if forLoggedInOnly()
      App.Transfer.Controller.form()

    members: ->
      return if forLoggedInOnly()
      App.User.Controller.members()
