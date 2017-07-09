@Lunchiatto.module 'User', (User, App, Backbone, Marionette, $, _) ->
  User.Member = Marionette.ItemView.extend(template: 'users/member')
