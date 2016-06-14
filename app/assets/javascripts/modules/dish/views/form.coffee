@Lunchiatto.module 'Dish', (Dish, App, Backbone, Marionette, $, _) ->
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
        types: ['fadeIn']
      Titleable: {}

    onFormSubmit: ->
      @model.save
        name: @ui.nameInput.val()
        price: @ui.priceInput.val().replace(',', '.')
      ,
        success: (model) ->
          App.router.navigate(model.successPath(), {trigger: true})

    _htmlTitle: ->
      return 'Edit Dish' if @model.get('id')
      'Add Dish'
