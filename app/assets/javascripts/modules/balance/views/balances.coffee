@Lunchiatto.module 'Balance', (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Balances = Marionette.CompositeView.extend
    template: 'balances/balances'
    getChildView: ->
      Balance.Balance
    childViewContainer: '.balances-container'

    behaviors:
      Titleable: {}

    templateHelpers: ->
      totalLabel: "Your balance to others #{@collection.total()}"

    collectionEvents:
      'sync': 'render'

    initialize: ->
      @collection.fetch()

      App.vent.on 'reload:finances', =>
        @collection.fetch()

    _htmlTitle: ->
      'Balances'
