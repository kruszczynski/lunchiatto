window.Lunchiatto.module('Panel', (Panel, App, Backbone, Marionette, $, _) =>
  Panel.Controller = {
    showNavbar() {
      const navbar = new Panel.Navbar({model: App.currentUser});
      App.root.navbar.show(navbar);
    }
  }
);
