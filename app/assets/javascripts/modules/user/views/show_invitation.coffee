@Lunchiatto.module 'User', (User, App, Backbone, Marionette, $, _) ->
  User.ShowInvitation = Marionette.ItemView.extend
    GOOGLE_OMNIAUTH_PATH: '/users/auth/google_oauth2'
    template: 'users/show_invitation'

    ui:
      completeInvitation: '.complete-invitation-button'

    triggers:
      'click @ui.completeInvitation': 'complete:invitation'

    onCompleteInvitation: ->
      window.location = @GOOGLE_OMNIAUTH_PATH
