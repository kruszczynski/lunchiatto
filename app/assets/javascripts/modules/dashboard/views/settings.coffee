@Lunchiatto.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Settings = Marionette.ItemView.extend
    template: 'dashboard/settings'

    ui:
      subtract: '.subtract'
      accountNumber: '.account-number'

    behaviors:
      Submittable: {}
      Animateable:
        types: ['fadeIn']
      Titleable: {}

    onFormSubmit: ->
      @model.save
        subtract_from_self: @ui.subtract.prop('checked')
        account_number: @ui.accountNumber.val()
      ,
        success: (model) ->
          App.router.navigate('/orders/today', {trigger: true})

    _htmlTitle: ->
      'Settings'
