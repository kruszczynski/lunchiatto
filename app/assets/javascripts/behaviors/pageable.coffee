@Lunchiatto.Behaviors.Pageable = Marionette.Behavior.extend
  ui:
    more: '.more'

  triggers:
    'click @ui.more': 'fetch:more'

  onShow: ->
    @_collectionReset()
    @view.collection.on('all:fetched', @_hideMore, this)
    @view.collection.on('reset', @_collectionReset, this)

  onFetchMore: ->
    @view.collection.more()

  _hideMore: ->
    @ui.more.addClass('hide')

  _collectionReset: ->
    @ui.more.toggleClass('hide', @view.collection.length < Lunchiatto.pageSize)
