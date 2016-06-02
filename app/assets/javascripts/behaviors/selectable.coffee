@Lunchiatto.Behaviors.Selectable = Marionette.Behavior.extend
  ui:
    select: 'select'

  onShow: ->
    @ui.select.chosen(width: '100%')
