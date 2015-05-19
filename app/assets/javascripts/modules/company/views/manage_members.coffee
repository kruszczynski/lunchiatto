@CodequestManager.module "Company", (Company, App, Backbone, Marionette, $, _) ->
  Company.ManageMembers = Marionette.LayoutView.extend
    template: "companies/manage_members"

    ui:
      members: ".members"

    regions:
      members: "@ui.members"

    behaviors:
      Animateable:
        types: ["fadeIn"]

    onRender: ->
      @_showMembers()

    _showMembers: ->
      members = @model.get('users')
      membersView = new Company.Members collection: members
      @members.show membersView

