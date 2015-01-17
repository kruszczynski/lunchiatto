@CodequestManager.module 'Order', (Order, App, Backbone, Marionette, $, _) ->
  Order.Shipping = Marionette.ItemView.extend
    template: 'orders/shipping'

    ui:
      form: 'form'
      shipping: '.shipping'
      
    triggers:
      'submit @ui.form': 'form:submit'
    
    onFormSubmit: ->
      @model.save
        shipping: @ui.shipping.val()
      ,
        success: (model) ->
          App.router.navigate "/orders/#{model.id}", {trigger: true}