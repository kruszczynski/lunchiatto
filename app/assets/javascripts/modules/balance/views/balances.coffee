@Lunchiatto.module "Balance", (Balance, App, Backbone, Marionette, $, _) ->
  Balance.Balances = Marionette.CompositeView.extend
    template: "balances/balances"
    getChildView: ->
      Balance.Balance
    childViewContainer: ".balances-container"

    behaviors:
      Titleable: {}

    templateHelpers: () ->
      total: @collection.total()
      type: @collection.type

    collectionEvents:
      "sync": "render"

    initialize: ->
      @type = @options.type
      @collection = new App.Entities.Balances [], type: @type
      @collection.fetch()

      App.vent.on "reload:finances", =>
        @collection.fetch()

    _htmlTitle: ->
      return "You 2 Others" if @type == 'balances'
      "Others 2 You"