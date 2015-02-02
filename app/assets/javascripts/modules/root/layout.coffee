@CodequestManager.module 'Root', (Root, App, Backbone, Marionette, $, _) ->
  Root.Layout = Marionette.LayoutView.extend
    el: 'body'
    
    regions:
      navbar: '#user-panel'
      content: '#content'