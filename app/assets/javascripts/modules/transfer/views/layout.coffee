@CodequestManager.module "Transfer", (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Layout = Marionette.LayoutView.extend
    template: "transfers/layout"

    ui:
      receivedTransfers: ".received-transfers"
      submittedTransfers: ".submitted-transfers"

    behaviors:
      Animateable:
        types: ["fadeIn"]

    regions:
      receivedTransfers: "@ui.receivedTransfers"
      submittedTransfers: "@ui.submittedTransfers"

    onRender: ->
      @_showTransfers("received")
      @_showTransfers("submitted")

    _showTransfers: (type) ->
      transfers = new App.Entities.Transfers [], type: type
      transfers.optionedFetch
        success: (transfers) =>
          view = new App.Transfer.List
            collection: transfers
          @["#{type}Transfers"].show view