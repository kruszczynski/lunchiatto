@CodequestManager.module 'Dishes', (Dishes, App, Backbone, Marionette, $, _) ->
  Dishes.Controller =
    form: (dish) ->
      editDish = new Dishes.Form model: dish
      App.content.show editDish
