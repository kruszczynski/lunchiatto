@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.Form = Marionette.ItemView.extend
    template: 'orders/form'

    ui:
      userSelect: '#user_id'
      restaurantInput: '#from'
      form: 'form'
      submit: '.submit'

    triggers:
      'submit @ui.form': 'form:submit'
      'click @ui.submit': 'form:submit'

    onFormSubmit: ->
      @model.save
        user_id: @ui.userSelect.val()
        from: @ui.restaurantInput.val()
      ,
        success: ->
          App.router.navigate '/dashboard', {trigger: true}