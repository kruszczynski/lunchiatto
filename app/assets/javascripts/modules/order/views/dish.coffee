@Lunchiatto.module "Order", (Order, App, Backbone, Marionette, $, _) ->
  Order.Dish = Marionette.ItemView.extend
    OVERWRITE_MESSAGE: "This might overwrite your current dish! Are you sure?"
    DELETE_MESSAGE: "Are you sure?"
    template: "orders/dish"
    tagName: "li"
    className: "dishes-list__item"

    ui:
      copyButton: ".copy-link"
      deleteButton: ".delete-link"

    triggers:
      "click @ui.copyButton": "copy:dish"
      "click @ui.deleteButton": "delete:dish"

    behaviors:
      Animateable:
        types: ["fadeIn"]

    onCopyDish: ->
      @model.copy() if @_confirmOverwrite()

    onDeleteDish: ->
      if confirm(@DELETE_MESSAGE)
        @$el.addClass('animate__fade-out')
        setTimeout =>
          @model.destroy()
        , App.animationDurationMedium


    serializeData: ->
      _.extend @model.toJSON(), order: @model.collection.order

    _confirmOverwrite: ->
      @model.yetToOrder(App.currentUser) || confirm(@OVERWRITE_MESSAGE)
