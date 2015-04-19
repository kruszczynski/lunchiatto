@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Dish = Backbone.Model.extend
    copyUrl: ->
      "/orders/#{@get('order_id')}/dishes/#{@id}/copy"

    urlRoot: ->
      "/orders/#{@get('order_id')}/dishes"

    copy: ->
      $.ajax
        url: @copyUrl()
        type: 'POST'
        success: (data) =>
          copiedDish = new Entities.Dish data
          currentDish = @collection.where user_id: data.user_id
          @collection.remove currentDish
          @collection.add copiedDish

    yetToOrder: (user) ->
      @collection.where(user_id: user.id).length is 0

    successPath: ->
      if @get('from_today')
        "/orders/today/#{@get('order_id')}"
      else
        "/orders/#{@get('order_id')}"

  Entities.Dishes = Backbone.Collection.extend
    model: Entities.Dish

    total: ->
      @reduce (memo, debt) ->
        memo + parseFloat(debt.get('price'))
      ,0