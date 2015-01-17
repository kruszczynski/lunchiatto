@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.Dish = Marionette.ItemView.extend
    OVERWRITE_MESSAGE: 'This might overwrite your current dish! Are you sure?'
    DELETE_MESSAGE: 'Are you sure?'
    template: 'orders/dish'
    tagName: 'tr'

    ui:
      copyButton: '.copy-link'
      deleteButton: '.delete-link'

    triggers:
      'click @ui.copyButton': 'copy:dish'
      'click @ui.deleteButton': 'delete:dish'

    onCopyDish: ->
      @model.copy() if confirm(@OVERWRITE_MESSAGE)

    onDeleteDish: ->
      @model.destroy() if confirm(@DELETE_MESSAGE)

    serializeData: ->
      _.extend @model.toJSON(), order: @model.collection.order
