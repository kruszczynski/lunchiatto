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
          @collection.add copiedDish

  Entities.Dishes = Backbone.Collection.extend
    model: Entities.Dish