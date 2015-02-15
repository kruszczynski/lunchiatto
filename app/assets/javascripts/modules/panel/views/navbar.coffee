@CodequestManager.module 'Panel', (Panel, App, Backbone, Marionette, $, _) ->
  Panel.Navbar = Marionette.ItemView.extend
    template: 'panel/navbar'
    className: 'fixed'

    modelEvents:
      'change': 'render'

    behaviors:
      Animateable:
        types: ["fadeIn"]

    onShow: ->
      $(document).foundation('topbar', 'reflow')