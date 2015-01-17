@CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Settings = Marionette.ItemView.extend
  	template: 'dashboard/settings'

  	ui:
      form: 'form'
      substract: '.substract'
      accountNumber: '.account-number'

    triggers:
      'submit @ui.form': 'form:submit'

    onFormSubmit: ->
      @model.save
        substract_from_self: @ui.substract.prop('checked')
        account_number: @ui.accountNumber.val()
      ,
        success: (model) ->
          App.router.navigate "/dashboard", {trigger: true}