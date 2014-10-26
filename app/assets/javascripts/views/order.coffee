CodequestManager.Views.Order = Backbone.View.extend

  template: JST['templates/order']

  events:
    'click [data-js=addDish]': 'addDish'

  render: ->
    @$el.html(@template())
    @

  addDish: (e) ->
    e.preventDefault()
    dishForm = new CodequestManager.Views.DishForm
    $('#dishModal').html(dishForm.render().el)
    $('#dishModal').foundation('reveal', 'open')

