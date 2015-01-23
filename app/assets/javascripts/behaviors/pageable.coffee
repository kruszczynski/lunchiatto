@CodequestManager.Behaviors.Pageable = Marionette.Behavior.extend
  ui:
    more: '.more'

  triggers:
    'click @ui.more': 'fetch:more'

  onShow: ->
    @view.collection.on 'all:fetched', @_hideMore, this
    @_hideMore() if @view.collection.length < CodequestManager.pageSize

  onFetchMore: ->
    @view.collection.more()

  _hideMore: ->
    @ui.more.addClass('hide')
