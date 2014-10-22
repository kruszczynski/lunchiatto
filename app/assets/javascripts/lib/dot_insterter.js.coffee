do ($ = jQuery, window, document) ->
  pluginName = "dotInserter"

  class DotInserter
    constructor: (@element, options) ->
      @$el = $(@element)
      @$el.on 'keyup', =>
        @onElementKeyup()

    onElementKeyup: ->
      val = @$el.val()
      if val.indexOf(',') isnt -1
        @$el.val(val.replace(',','.'))

    $.fn[pluginName] = (options) ->
      options ||= {}
      @each ->
        if !$.data(@, "plugin_#{pluginName}")
          $.data(@, "plugin_#{pluginName}", new DotInserter(@, options))
        return
      return

  $ ->
    $('[data-toggle="dot-inserter"]').dotInserter()