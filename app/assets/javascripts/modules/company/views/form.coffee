@Lunchiatto.module 'Company', (Company, App, Backbone, Marionette, $, _) ->
  Company.Form = Marionette.ItemView.extend
    template: 'companies/form'

    ui:
      nameInput: '.name'

    behaviors:
      Errorable:
        fields: ['name']
      Submittable: {}
      Titleable: {}

    onFormSubmit: ->
      @model.save
        name: @ui.nameInput.val()
      ,
        success: (model) =>
          gon.companyName = model.get('name')
          App.vent.trigger('rerender:topbar')
          @render()

    _htmlTitle: ->
      'Edit Company'
