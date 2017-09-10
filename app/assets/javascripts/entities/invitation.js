window.Lunchiatto.module('Entities', function(Entities, App, Backbone, Marionette, $, _) {
  Entities.Invitation = Backbone.Model.extend({
    urlRoot: '/api/invitations'
  });

  return Entities.Invitations = Backbone.Collection.extend({
    model: Entities.Invitation,

    url() {
      return '/api/invitations';
    }
  });
});
