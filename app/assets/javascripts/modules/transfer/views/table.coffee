@CodequestManager.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Table = Marionette.CompositeView.extend
    template: 'transfers/table'
    templateHelpers: ->
      type: @collection.type
    getChildView: ->
      Transfer.Row
    childViewContainer: 'tbody'
    childViewOptions: ->
      type: @collection.type