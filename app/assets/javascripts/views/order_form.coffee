CodequestManager.Views.OrderForm = Backbone.View.extend

  template: JST['templates/new_order']

  events:
    'click [data-js=createOrder]': 'createOrder'

  render: ->
    @$el.html(@template())
    @

  createOrder: (e) ->
    e.preventDefault()
    user = $('[data-js=user_id]').val()
    from = $('[data-js=from]').val()
    success = ->
      $('#myModal').foundation('reveal', 'close')
      order = new CodequestManager.Views.Order
      $('.wrapper').html(order.render().el)

    $.ajax
      url: "/orders"
      type: 'POST'
      data:
        order:
          user_id: user
          from: from
      success: success
