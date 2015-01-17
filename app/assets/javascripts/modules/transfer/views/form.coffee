@CodequestManager.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Form = Marionette.ItemView.extend
    template: 'transfers/form'

    ui:
      userSelect: '.user-id'
      amountInput: '.amount'

    behaviors:
      Errorable:
        fields: ['amount', 'to']
      Submittable: {}

    onFormSubmit: ->
      @model.save
        to_id: @ui.userSelect.val()
        amount: @ui.amountInput.val().replace(',','.')
      ,
        success: ->
          App.vent.trigger 'reload:current:user'
          App.router.navigate "/finances", {trigger: true}
