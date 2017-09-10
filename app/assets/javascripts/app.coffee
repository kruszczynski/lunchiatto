@Lunchiatto = do (Backbone, Marionette) ->
  Marionette.Renderer.oldRender = Marionette.Renderer.render
  Marionette.Renderer.render = (template, data) ->
    template = template() if typeof template == 'function'

    unless JST[template]
      return Marionette.Renderer.oldRender(template, data)
    return JST[template](data)

  App = new Marionette.Application()

  App.Behaviors = {}

  App.currentUser = undefined

  App.pageSize = 10
  App.animationDurationMedium = 500

  App.usersWithoutMe = ->
    _.reject(gon.usersForSelect, (user) -> user.id == App.currentUser.id)

  App.on 'start', ->
    $title = $('head title')
    App.router = new App.Router
      controller: App.Controller

    App.root = new App.Root.Layout

    Marionette.Behaviors.behaviorsLookup = ->
      App.Behaviors
    App.currentUser = new App.Entities.User(gon.currentUser)
    App.vent.on 'reload:current:user', ->
      App.currentUser.fetch()
    App.vent.on 'set:html:title', (title) ->
      $title.text(title)

    $(document).foundation()
    if App.currentUser.loggedIn()
      App.Panel.Controller.showNavbar()

    Backbone.history.start
      pushState: true

    menuIcon = $('.menu-icon')
    navigation = $('.top-bar')

    $('body').on 'click', '[data-navigate]', (e) ->
      return if e.metaKey
      e.preventDefault()
      $title.text('Lunchiatto')
      href = $(e.currentTarget).attr('href')
      App.router.navigate(href, {trigger: true})
      menuIcon.click() if navigation.hasClass('expanded')
      navigation.click()
  App

$ ->
  Lunchiatto.start()
