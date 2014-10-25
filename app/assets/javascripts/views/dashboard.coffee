CodequestManager.Views.Dashboard = Backbone.View.extend

  el: '.wrapper'

  template: JST['new-order']

  events:
    'click [data-js=newOrder]': 'createOrder'

  createOrder: (event) ->
    event.preventDefault()
    $('#myModal').foundation('reveal', 'open')