@Lunchiatto.module 'Dish', (Dish, App, Backbone, Marionette, $, _) ->
  Dish.Controller =
    form: (dish) ->
      editDish = new Dish.Form model: dish
      App.root.content.show editDish
