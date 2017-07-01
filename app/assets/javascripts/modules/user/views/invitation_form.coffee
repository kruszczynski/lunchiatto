@Lunchiatto.module 'User', (User, App, Backbone, Marionette, $, _) ->
  User.InvitationForm = Marionette.ItemView.extend
    template: 'users/invitation_form'

    ui:
      emailInput: '.email'

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
      @ui.emailInput.val('')
