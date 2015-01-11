@CodequestManager.module 'Dishes', (Dishes, App, Backbone, Marionette, $, _) ->
  Dishes.Form = Marionette.ItemView.extend
    template: 'dishes/form'

    ui:
      priceInput: '#price'
      nameInput: '#name'
      submitButton: '.submit'

    triggers:
      'click @ui.submitButton': 'save:dish'

    onShow: ->
      @ui.priceInput.dotInserter()

    onSaveDish: ->
      @model.save
        name: @ui.nameInput.val()
        price: @ui.priceInput.val()
      ,
        success: ->
          App.router.navigate '/dashboard', {trigger: true}