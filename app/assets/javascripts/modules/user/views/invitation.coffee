@Lunchiatto.module 'User', (User, App, Backbone, Marionette, $, _) ->
  User.Invitation = Marionette.ItemView.extend
    DELETE_MESSAGE: 'Are you sure?'

    template: 'users/invitation'

    behaviors:
      Animateable:
        types: ['fadeIn']

    ui:
      deleteButton: '.delete-invitation'

    triggers:
      'click @ui.deleteButton': 'delete:invitation'

    onDeleteInvitation: ->
      if confirm(@DELETE_MESSAGE)
        @$el.addClass('animate__fade-out')
        setTimeout =>
          @model.destroy()
        , App.animationDurationMedium
