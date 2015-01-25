@CodequestManager.Behaviors.Submittable = Marionette.Behavior.extend
  ui:
    form: 'form'

  triggers:
    'submit @ui.form': 'form:submit'

  onShow: ->
    @_focusFistInput() unless @view.model.id

  _focusFistInput: ->
    @ui.form.find('input:first').focus()