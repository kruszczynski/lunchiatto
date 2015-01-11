do (App = @CodequestManager) ->
  App.Controller =
    dashboard: ->
      App.Dashboard.Controller.layout()

    editDish: (orderId, dishId) ->
      dish = new App.Entities.Dish order_id: orderId, id: dishId
      dish.fetch
        success: (dish) ->
          App.Dishes.Controller.form(dish)

    newDish: (orderId) ->
      dish = new App.Entities.Dish order_id: orderId, user_id: App.currentUser.id
      App.Dishes.Controller.form(dish)
    finances: ->
      console.log 'finances'