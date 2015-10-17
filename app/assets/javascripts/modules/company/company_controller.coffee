@Lunchiatto.module "Company", (Company, App, Backbone, Marionette, $, _) ->
  Company.Controller =
    members: ->
      companyId = App.currentUser.get("company_id")
      company = new App.Entities.Company id: companyId
      company.fetch success: @showMembers

    # That's not an action, it's a callback
    showMembers: (company) ->
      membersView = new Company.ManageMembers model: company
      App.root.content.show membersView

    edit: ->
      companyId = App.currentUser.get("company_id")
      company = new App.Entities.Company id: companyId
      company.fetch success: @showEdit

    # That's not an action, it's a callback
    showEdit: (company) ->
      formView = new Company.Form model: company
      App.root.content.show formView
