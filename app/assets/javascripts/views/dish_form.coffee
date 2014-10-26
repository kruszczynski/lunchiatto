CodequestManager.Views.DishForm = Backbone.View.extend

  template: JST['templates/new_dish']

  render: ->
    @$el.html(@template())
    @