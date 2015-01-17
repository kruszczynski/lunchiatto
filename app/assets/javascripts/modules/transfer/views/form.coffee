@CodequestManager.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Form = Marionette.ItemView.extend
    template: 'transfers/form'

    ui:
      userSelect: '.user-id'
      amountInput: '.amount'
      form: 'form'

    triggers:
      'submit @ui.form': 'form:submit'

    onFormSubmit: ->
      @model.save
        user_id: @ui.userSelect.val()
        amount: @ui.amountInput.val().replace(',','.')
      ,
        success: ->
          App.vent.trigger 'reload:current:user'
          App.router.navigate "/finances", {trigger: true}
