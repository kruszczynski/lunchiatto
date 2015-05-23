@CodequestManager.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  Entities.Invitation = Backbone.Model.extend
    urlRoot: "/invitations"

  Entities.Invitations = Backbone.Collection.extend
    model: Entities.Invitation