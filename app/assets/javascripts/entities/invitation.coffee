@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Invitation = Backbone.Model.extend
    urlRoot: "/api/invitations"

  Entities.Invitations = Backbone.Collection.extend
    model: Entities.Invitation