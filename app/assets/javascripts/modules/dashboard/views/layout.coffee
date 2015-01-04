CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.Layout = Marionette.LayoutView.extend
    template: 'dashboard/layout'

    initialize: ->
      @model = new App.Entities.TodaysOrder
      @model.fetch()