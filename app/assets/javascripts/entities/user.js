window.Lunchiatto.module('Entities', function(Entities, App, Backbone, Marionette, $, _) {
  Entities.User = Backbone.Model.extend({
    urlRoot() {
      return '/api/users';
    },

    loggedIn() {
      return !isNaN(this.get('id'));
    }
  });

  return Entities.Users = Backbone.Collection.extend({
    model: Entities.User,

    url() {
      return '/api/users';
    }
  });
});
