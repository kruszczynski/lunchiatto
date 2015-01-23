@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Transfer = Backbone.Model.extend
    urlRoot: ->
      "/transfers"

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
      "/#{@type}_transfers"

    initialize: (models, options)->
      @type = options.type

    page: 1

    more: ->
      @page += 1
      @fetch
        data:
          page: @page
        remove: false
        success: (collection, data) =>
          @trigger 'all:fetched' if data.length < App.pageSize
