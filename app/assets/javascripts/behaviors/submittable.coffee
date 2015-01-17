@CodequestManager.Behaviors.Submittable = Marionette.Behavior.extend
  ui:
    form: 'form'

  triggers:
    'submit @ui.form': 'form:submit'
