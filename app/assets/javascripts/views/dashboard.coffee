CodequestManager.Views.Dashboard = Backbone.View.extend

  el: '.wrapper'

  events:
    'click [data-js=newOrder]': 'newOrder'

  newOrder: (e) ->
    e.preventDefault()
    orderForm = new CodequestManager.Views.OrderForm
    $('#myModal').html(orderForm.render().el)
    $('#myModal').foundation('reveal', 'open')
