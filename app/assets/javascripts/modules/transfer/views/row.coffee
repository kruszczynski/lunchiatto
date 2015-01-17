@CodequestManager.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Row = Marionette.ItemView.extend
    REJECT_MESSAGE: 'The transfer will be rejected! Are you sure?'
    ACCEPT_MESSAGE: 'Are you sure?'
    template: 'transfers/row'
    tagName: 'tr'
    templateHelpers: ->
      type: @type

    ui:
      acceptButton: '.accept-transfer'
      rejectButton: '.reject-transfer'

    triggers:
      'click @ui.acceptButton': 'accept:transfer'
      'click @ui.rejectButton': 'reject:transfer'

    initialize: (options) ->
      @model.on 'change', @_reload, this
      @model.on 'change', @render, this
      @type = options.type

    onRejectTransfer: ->
      @model.reject()

    onAcceptTransfer: ->
      @model.accept()

    _reload: ->
      App.vent.trigger 'reload:current:user'
      App.vent.trigger 'reload:finances'