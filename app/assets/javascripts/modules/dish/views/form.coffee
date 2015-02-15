@CodequestManager.module 'Dish', (Dish, App, Backbone, Marionette, $, _) ->
  Dish.Form = Marionette.ItemView.extend
    template: 'dishes/form'

    ui:
      priceInput: '.price'
      nameInput: '.name'

    behaviors:
      Errorable:
        fields: ['name', 'price']
      Submittable: {}
      Animateable:
        types: ["fadeIn"]

    onFormSubmit: ->
      @model.save
        name: @ui.nameInput.val()
        price: @ui.priceInput.val().replace(',','.')
      ,
        success: (model) ->
          App.router.navigate "/orders/#{model.get('order_id')}", {trigger: true}
