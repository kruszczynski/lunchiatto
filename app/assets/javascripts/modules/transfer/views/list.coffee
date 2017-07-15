@Lunchiatto.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.List = Marionette.CompositeView.extend
    template: 'transfers/list'
    templateHelpers: ->
      type: @collection.type
      usersForSelect: App.usersWithoutMe()
      selectedUser: @collection.userId
    getChildView: ->
      Transfer.Item
    getEmptyView: ->
      Transfer.Empty
    childViewContainer: '.transfers'
    childViewOptions: ->
      type: @collection.type

    behaviors:
      Pageable: {}
      Selectable: {}

    ui:
      userSelect: '.user-id'

    triggers:
      'change @ui.userSelect': 'filter:transfers'

    onFilterTransfers: ->
      @collection.userId = @ui.userSelect.val()
      @collection.page = 1
      @collection.optionedFetch(reset: true)
