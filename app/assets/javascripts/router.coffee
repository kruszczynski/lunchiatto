CodequestManager.Routers.MainRouter = Backbone.Router.extend

  routes:
    'users/dashboard': 'dashboard'

  dashboard: ->
    new CodequestManager.Views.Dashboard

router = new CodequestManager.Routers.MainRouter()

Backbone.history.start({pushState: true})