@Lunchiatto.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Form = Marionette.ItemView.extend
    template: 'transfers/form'

    ui:
      userSelect: '.user-id'
      amountInput: '.amount'
      accountNumber: '.account-number'
      accountNumberSection: '.account-number-section'

    triggers:
      'change @ui.userSelect': 'user:selected'

    behaviors:
      Errorable:
        fields: ['amount', 'to']
      Submittable: {}
      Animateable:
        types: ['fadeIn']
      Titleable: {}
      Selectable: {}

    onShow: ->
      @onUserSelected() if @model.get('to_id')

    onUserSelected: ->
      userId = @ui.userSelect.val()
      if userId
        user = _.find(gon.usersForSelect, (user) -> +user.id is +userId)
        @ui.accountNumber.text(user.account_number)
      @ui.accountNumberSection.toggleClass('hide', !userId)

    onFormSubmit: ->
      @model.save
        to_id: @ui.userSelect.val()
        amount: @ui.amountInput.val().replace(',', '.')
      ,
        success: ->
          App.vent.trigger('reload:current:user')
          App.router.navigate('/transfers', {trigger: true})

    _htmlTitle: ->
      'New Transfer'
