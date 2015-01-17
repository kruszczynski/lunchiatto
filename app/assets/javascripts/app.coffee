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
    content: '#content'

  App.currentUser = undefined

  App.addInitializer ->
    App.router = new App.Router
      controller: App.Controller

  App.on 'start', ->
    App.currentUser = new App.Entities.User gon.current_user
    App.vent.on 'reload:current:user', ->
      App.currentUser.fetch()
    $(document).foundation()

    App.Panel.Controller.showNavbar()

    Backbone.history.start
      pushState: true
      root: '/app'

    $('body').on 'click', '[data-navigate]', (e) ->
      e.preventDefault()
      href = $(e.currentTarget).attr('href')
      App.router.navigate href, {trigger: true}

  App

$ ->
  CodequestManager.start()