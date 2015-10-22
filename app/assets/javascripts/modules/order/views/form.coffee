@Lunchiatto.module "Order", (Order, App, Backbone, Marionette, $, _) ->
  Order.Form = Marionette.ItemView.extend
    template: "orders/form"

    ui:
      userSelect: ".user-id"
      restaurantInput: ".from"
      shipping: ".shipping"

    behaviors:
      Errorable:
        fields: ["user", "from", "shipping"]
      Submittable: {}
      Animateable:
        types: ["fadeIn"]
      Titleable: {}
      Selectable: {}

    onFormSubmit: ->
      @model.save
        user_id: @ui.userSelect.val()
        from: @ui.restaurantInput.val()
        shipping: @ui.shipping.val()
      ,
        success: (model) ->
          App.router.navigate model.successPath(), {trigger: true}

    _htmlTitle: ->
      return "Edit Order" if @model.get('id')
      "Add Order"