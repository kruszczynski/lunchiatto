@CodequestManager.module 'Dish', (Dish, App, Backbone, Marionette, $, _) ->
  Dish.Form = Marionette.ItemView.extend
    template: 'dishes/form'

    ui:
      priceInput: '#price'
      nameInput: '#name'
      submitButton: '.submit'
      form: 'form'

    triggers:
      'submit @ui.form': 'form:submit'
      'click @ui.submitButton': 'form:submit'

    onShow: ->
      @ui.priceInput.dotInserter()

    onFormSubmit: ->
      @model.save
        name: @ui.nameInput.val()
        price: @ui.priceInput.val()
      ,
        success: ->
          App.router.navigate '/dashboard', {trigger: true}