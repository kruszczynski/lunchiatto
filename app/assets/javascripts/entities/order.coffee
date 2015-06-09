@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Order = Backbone.Model.extend

    urlRoot: ->
      "/api/orders"

    parse: (data) ->
      data.dishes = new Entities.Dishes data.dishes
      data.dishes.order = this
      data

    currentUserOrdered: ->
      @get('dishes').where(user_id: App.currentUser.id).length isnt 0

    changeStatus: ->
      $.ajax
        type: 'PUT'
        url: "#{@url()}/change_status"
        success: (data) =>
          @set(@parse(data))
          App.vent.trigger 'reload:current:user' if data.status is 'delivered'

    total: ->
      (@get('dishes').total()+parseFloat(@get('shipping'))).toFixed(2)

    successPath: ->
      if @get('from_today')
        "/orders/today/#{@id}"
      else
        "/orders/#{@id}"

  Entities.Orders = Backbone.Collection.extend
    model: Entities.Order
    url: '/api/orders'

    page: 1

    more: ->
      @page += 1
      @fetch
        data:
          page: @page
        remove: false
        success: (collection, data) =>
          @trigger 'all:fetched' if data.length < App.pageSize
