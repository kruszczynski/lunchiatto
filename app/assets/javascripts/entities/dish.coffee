@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Dish = Backbone.Model.extend
    copyUrl: ->
      "/orders/#{@_orderId()}/dishes/#{@id}/copy"

    copy: ->
      $.ajax
        url: @copyUrl()
        type: 'POST'
        success: (data) =>
          copiedDish = new Entities.Dish data
          @collection.add copiedDish

    _orderId: ->
      @collection.order.id

  Entities.Dishes = Backbone.Collection.extend
    model: Entities.Dish

    url: ->
      "/orders/#{@order.id}/dishes"
