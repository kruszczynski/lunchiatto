@CodequestManager = do (Backbone, Marionette) ->
  Marionette.Renderer.oldRender = Marionette.Renderer.render
  Marionette.Renderer.render = (template, data) ->
    template = template() if typeof template == 'function'

    unless JST[template]
      return Marionette.Renderer.oldRender(template, data)
    return JST[template](data)

  App = new Marionette.Application()

  App.addRegions
    navbar: '#user-panel'

  App.currentUser = undefined

  App.addInitializer ->
    App.router = new App.Router
      controller: App.Controller

  App.on 'start', ->
    App.currentUser = new App.Entities.CurrentUser gon.current_user
    $(document).foundation()

    App.Panel.showNavbar()

    Backbone.history.start
      pushState: true

    $('body').on 'click', '[data-navigate]', (e) ->
      e.preventDefault()
      href = $(e.currentTarget).attr('href')
      App.router.navigate href, {trigger: true}

  App

$ ->
  CodequestManager.start()