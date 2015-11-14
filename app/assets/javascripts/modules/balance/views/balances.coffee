@Lunchiatto.module 'Balance', (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Balances = Marionette.CompositeView.extend
    template: 'balances/balances'
    getChildView: ->
      Balance.Balance
    childViewContainer: '.balances-container'

    balancesHeader: 'Your balance to others'
    debtsHeader: 'Others\' balance to you'

    balancesTitle: 'You 2 Others'
    debtsTitle: 'Others 2 You'

    behaviors:
      Titleable: {}

    templateHelpers: ->
      # calls balancesHeader, debtsHeader
      headerText = @["#{@collection.type}Header"]
      totalLabel: "#{headerText} #{@collection.total()}"

    collectionEvents:
      'sync': 'render'

    initialize: ->
      @collection.fetch()

      App.vent.on 'reload:finances', =>
        @collection.fetch()

    _htmlTitle: ->
      # calls balancesTitle, debtsTitle
      @["#{@collection.type}Title"]
