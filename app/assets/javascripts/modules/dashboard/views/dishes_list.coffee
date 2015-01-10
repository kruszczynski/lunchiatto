@CodequestManager.module 'Dashboard', (Dashboard, App, Backbone, Marionette, $, _) ->
  Dashboard.DishesList = Marionette.CompositeView.extend
    template: 'dashboard/dishes_list'