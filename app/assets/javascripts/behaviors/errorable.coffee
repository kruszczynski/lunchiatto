@Lunchiatto.Behaviors.Errorable = Marionette.Behavior.extend
  modelEvents:
    error: 'onModelError'
    sync: "hideErrors"

  ui:
    errorMessages: 'small.error'
    fullError: '.full-error'
    fullErrorParagraph: '.full-error p'

  initialize: (options) ->
    @fields = options.fields
    _.each options.fields, (field) =>
      @ui["#{field}Label"] = ".#{field}-label"

  onModelError: (model, data) ->
    @hideErrors()
    if data && data.responseJSON
      message = ""
      _.each data.responseJSON.errors, (errors, key)=>
        if _.contains(@fields, key)
          @_showError(errors, key)
        else
          if key is 'date'
            message += Humanize.capitalize("#{errors.join(', ')}!")
          else
            message += Humanize.capitalize("#{key} #{errors.join(', ')}!")
          message += "<br/>"
      @_showFulError(message) if message

  hideErrors: ->
    @ui.fullErrorParagraph.empty()
    @ui.fullError.addClass('hide')
    @ui.errorMessages.addClass('hide')
    _.each @fields, (field) =>
      @ui["#{field}Label"].removeClass('error')

  _showError: (errors, key) ->
    label = @ui["#{key}Label"]
    label.addClass('error')
    label.find('.error').removeClass('hide').text("\"#{key}\" #{errors.join(', ')}")

  _showFulError: (message) ->
    @ui.fullError.removeClass('hide')
    @ui.fullErrorParagraph.html(message)
