@Lunchiatto.module 'User', (User, App, Backbone, Marionette, $, _) ->
  User.Controller =
    members: ->
      membersView = new User.ManageMembers()
      App.root.content.show(membersView)
