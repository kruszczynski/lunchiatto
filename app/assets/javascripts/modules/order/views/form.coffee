@CodequestManager.module "Order", (Order, App, Backbone, Marionette, $, _) ->
  Order.Form = Marionette.ItemView.extend
    template: "orders/form"

    ui:
      userSelect: ".user-id"
      restaurantInput: ".from"
      shipping: ".shipping"

    behaviors:
      Errorable:
        fields: ["user", "from"]
      Submittable: {}
      Animateable:
        type: "fadeIn"

    onFormSubmit: ->
      @model.save
        user_id: @ui.userSelect.val()
        from: @ui.restaurantInput.val()
        shipping: @ui.shipping.val()
      ,
        success: (model) ->
          App.router.navigate "/orders/#{model.id}", {trigger: true}