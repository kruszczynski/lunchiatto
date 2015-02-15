@CodequestManager.Behaviors.Animateable = Marionette.Behavior.extend
  initialize: (options) ->
    return unless options.type
    try
      @[options.type]()
    catch error
      throw new Error "\"#{options.type}\" not found on Animateable"

  fadeIn: ->
    @view.className += " animate__fade-in"