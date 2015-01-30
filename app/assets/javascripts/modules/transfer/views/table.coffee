@CodequestManager.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Table = Marionette.CompositeView.extend
    template: 'transfers/table'
    templateHelpers: ->
      type: @collection.type
      selectedUser: @collection.userId
    getChildView: ->
      Transfer.Row
    childViewContainer: 'tbody'
    childViewOptions: ->
      type: @collection.type

    behaviors:
      Pageable: {}

    ui:
      userSelect: '.user-id'

    triggers:
      'change @ui.userSelect': 'filter:transfers'

    onFilterTransfers: ->
      @collection.userId = @ui.userSelect.val()
      @collection.page = 1
      @collection.optionedFetch(reset: true)