@Lunchiatto.module 'Page', (Page, App, Backbone, Marionette, $, _) ->
  Page.Index = Marionette.ItemView.extend
    GOOGLE_OMNIAUTH_PATH: '/users/auth/google_oauth2'
    template: 'pages/index'

    ui:
      googleSignUpButton: '.google-sign-up'

    triggers:
      'click @ui.googleSignUpButton': 'google:sign:up'

    onGoogleSignUp: ->
      window.location = @GOOGLE_OMNIAUTH_PATH
