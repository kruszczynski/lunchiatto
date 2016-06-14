@Lunchiatto.module 'Panel', (Panel, App, Backbone, Marionette, $, _) ->
  Panel.Controller =
    showNavbar: ->
      navbar = new Panel.Navbar(model: App.currentUser)
      App.root.navbar.show(navbar)
