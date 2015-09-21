@Lunchiatto.Behaviors.Animateable = Marionette.Behavior.extend
  initialize: (options) ->
    return unless options.types
    _.each options.types, (type) =>
      @[type]()

  fadeIn: ->
    @view.className += " animate__fade-in"