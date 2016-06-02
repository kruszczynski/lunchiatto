@Lunchiatto.module 'Company', (Company, App, Backbone, Marionette, $, _) ->
  Company.Members = Marionette.CompositeView.extend
    template: 'companies/members'

    getChildView: ->
      Company.Member

    childViewContainer: '@ui.membersList'

    className: 'users-list'

    ui:
      membersList: '.members-list'
