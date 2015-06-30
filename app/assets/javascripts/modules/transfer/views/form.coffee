@CodequestManager.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Form = Marionette.ItemView.extend
    template: 'transfers/form'

    ui:
      userSelect: '.user-id'
      amountInput: '.amount'
      accountNumberInput: ".account-number-input"
      accountNumberSection: ".account-number-section"

    triggers:
      "change @ui.userSelect": "user:selected"

    behaviors:
      Errorable:
        fields: ['amount', 'to']
      Submittable: {}
      Animateable:
        types: ["fadeIn"]

    onUserSelected: ->
      userId = @ui.userSelect.val()
      if userId
        user = _.find(gon.usersForSelect, (user) -> +user.id is +userId)
        @ui.accountNumberInput.val(user.account_number)
      @ui.accountNumberSection.toggleClass('hide', !userId)

    onFormSubmit: ->
      @model.save
        to_id: @ui.userSelect.val()
        amount: @ui.amountInput.val().replace(',','.')
      ,
        success: ->
          App.vent.trigger 'reload:current:user'
          App.router.navigate "/transfers", {trigger: true}
