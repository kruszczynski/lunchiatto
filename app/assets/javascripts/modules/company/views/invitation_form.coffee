@Lunchiatto.module "Company", (Company, App, Backbone, Marionette, $, _) ->
  Company.InvitationForm = Marionette.ItemView.extend
    template: "companies/invitation_form"

    ui:
      emailInput: ".email"

    behaviors:
      Errorable:
        fields: ['email']
      Submittable: {}

    initialize: (options) ->
      @invitations = options.invitations
      @model = new App.Entities.Invitation

    onFormSubmit: ->
      @model.save email: @ui.emailInput.val(),
        success: (model) => @saveSuccess(model)

    saveSuccess: (model) ->
      @invitations.add(model.clone())
      @model.set(email: null, id: null)
      @ui.emailInput.val("")