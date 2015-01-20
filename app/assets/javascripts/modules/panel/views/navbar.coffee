@CodequestManager.module 'Panel', (Panel, App, Backbone, Marionette, $, _) ->
  Panel.Navbar = Marionette.ItemView.extend
    template: 'panel/navbar'
    className: 'fixed'

    modelEvents:
      'change': 'render'

    onShow: ->
      $(document).foundation('topbar', 'reflow')