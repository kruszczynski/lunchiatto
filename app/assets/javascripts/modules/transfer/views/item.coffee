@Lunchiatto.module 'Transfer', (Transfer, App, Backbone, Marionette, $, _) ->
  Transfer.Item = Marionette.ItemView.extend
    REJECT_MESSAGE: 'The transfer will be rejected! Are you sure?'
    ACCEPT_MESSAGE: 'Are you sure?'
    template: 'transfers/item'
    tagName: 'div'
    className: 'transfer-box'
    templateHelpers: ->
      type: @type

    ui:
      acceptButton: '.accept-transfer'
      rejectButton: '.reject-transfer'

    modelEvents:
      'change': '_reload'

    triggers:
      'click @ui.acceptButton': 'accept:transfer'
      'click @ui.rejectButton': 'reject:transfer'

    initialize: (options) ->
      @type = options.type

    onRejectTransfer: ->
      @model.reject()

    onAcceptTransfer: ->
      @model.accept()

    _reload: ->
      @render()
      App.vent.trigger('reload:current:user')
      App.vent.trigger('reload:finances')
