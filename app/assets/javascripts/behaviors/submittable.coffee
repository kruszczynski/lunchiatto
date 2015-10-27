@Lunchiatto.Behaviors.Submittable = Marionette.Behavior.extend
  ui:
    form: 'form'
    submitButton: "[type='submit']"

  triggers:
    'submit @ui.form': 'form:submit'

  onShow: ->
    @listenTo(@view.model, 'error', @_enableSubmit, this)
    @listenTo(@view.model, 'sync', @_enableSubmit, this)
    @_focusFistInput() unless @view.model.id

  onFormSubmit: ->
    @ui.submitButton.prop('disabled',true)

  _focusFistInput: ->
    @ui.form.find('input:first').focus()

  _enableSubmit: ->
    @ui.submitButton.prop('disabled',false)