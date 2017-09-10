window.Lunchiatto.module('Dashboard', (Dashboard, App, Backbone, Marionette, $, _) =>
  Dashboard.Controller = {
    settings(user) {
      const settingsView = new Dashboard.Settings({model: user});
      App.root.content.show(settingsView);
    }
  }
);
