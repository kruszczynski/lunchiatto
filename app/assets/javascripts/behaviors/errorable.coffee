@CodequestManager.Behaviors.Errorable = Marionette.Behavior.extend
  modelEvents:
    error: 'onModelError'

  ui:
    errorMessages: 'small.error'

  initialize: (options) ->
    @fields = options.fields
    _.each options.fields, (field) =>
      @ui["#{field}Label"] = ".#{field}-label"

  onModelError: (model, data) ->
    @_hideErrors()
    if data && data.responseJSON
      _.each data.responseJSON.errors, @_showError, this 

  _hideErrors: ->
    @ui.errorMessages.addClass('hide')
    _.each @fields, (field) =>
      @ui["#{field}Label"].removeClass('error')

  _showError: (errors,key) ->
    label = @ui["#{key}Label"]
    label.addClass('error')
    label.find('.error').removeClass('hide').text("\"#{key}\" #{errors.join(', ')}")
