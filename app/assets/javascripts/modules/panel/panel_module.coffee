CodequestManager.module 'Panel', (Panel, App, Backbone, Marionette, $, _) ->
  Panel.showNavbar = ->
    navbar = new Panel.Navbar model: App.currentUser
    App.navbar.show(navbar)