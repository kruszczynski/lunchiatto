window.Lunchiatto.module('Page', (Page, App, Backbone, Marionette, $, _) =>
  Page.Controller = {
    index() {
      App.root.content.show(new Page.Index());
    }
  }
);
