@CodequestManager.Behaviors.Pageable = Marionette.Behavior.extend
  ui:
    more: '.more'

  triggers:
    'click @ui.more': 'fetch:more'

  onShow: ->
    @view.collection.on 'all:fetched', @_allFetched, this

  onFetchMore: ->
    @view.collection.more()

  _allFetched: ->
    @ui.more.addClass('hide')
