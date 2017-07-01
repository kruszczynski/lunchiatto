@Lunchiatto.module 'Company', (Company, App, Backbone, Marionette, $, _) ->
  Company.Controller =
    members: ->
      membersView = new Company.ManageMembers()
      App.root.content.show(membersView)
