@Lunchiatto.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Transfer = Backbone.Model.extend
    urlRoot: ->
      "/api/transfers"

    accept: ->
      $.ajax
        type: 'PUT'
        url: "#{@url()}/accept"
        success: (data) =>
          @set(data)

    reject: ->
      $.ajax
        type: 'PUT'
        url: "#{@url()}/reject"
        success: (data) =>
          @set(data)


  Entities.Transfers = Backbone.Collection.extend
    model: Entities.Transfer
    url: ->
      "/api/#{@type}_transfers"

    initialize: (models, options)->
      @type = options.type

    page: 1
    userId: ''

    more: ->
      @page += 1
      @fetch
        data: @_getData()
        remove: false
        success: (collection, data) =>
          @trigger 'all:fetched' if data.length < App.pageSize

    optionedFetch: (options) ->
      extendedOptions = _.extend(data: @_getData(), options)
      Backbone.Collection::fetch.call(this, extendedOptions)

    _getData: ->
      {page: @page, user_id: @userId}
