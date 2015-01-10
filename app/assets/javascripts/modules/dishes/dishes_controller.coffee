@CodequestManager.module 'Dishes', (Dishes, App, Backbone, Marionette, $, _) ->
  Dishes.Controller =
    form: (dish) ->
      console.log 'dishes edit'