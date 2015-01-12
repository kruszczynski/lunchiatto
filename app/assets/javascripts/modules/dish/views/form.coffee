@CodequestManager.module 'Dish', (Dish, App, Backbone, Marionette, $, _) ->
  Dish.Form = Marionette.ItemView.extend
    template: 'dishes/form'

    ui:
      priceInput: '.price'
      nameInput: '.name'
      form: 'form'

    triggers:
      'submit @ui.form': 'form:submit'

    onFormSubmit: ->
      @model.save
        name: @ui.nameInput.val()
        price: @ui.priceInput.val().replace(',','.')
      ,
        success: ->
          App.router.navigate '/dashboard', {trigger: true}