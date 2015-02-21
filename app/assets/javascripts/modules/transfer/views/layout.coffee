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
      @_showTransfers()

    _showTransfers: ->
      receivedTransfers = new App.Entities.Transfers [], type: "received"
      receivedTransfers.optionedFetch
        success: (transfers) =>
          receivedView = new App.Transfer.Table
            collection: transfers
          @receivedTransfers.show receivedView
      submittedTransfers = new App.Entities.Transfers [], type: "submitted"
      submittedTransfers.optionedFetch
        success: (transfers) =>
          submittedView = new App.Transfer.Table
            collection: transfers
          @submittedTransfers.show submittedView