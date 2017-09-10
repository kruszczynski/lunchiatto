window.Lunchiatto.module('Panel', function(Panel, App, Backbone, Marionette, $, _) {
  return Panel.Navbar = Marionette.ItemView.extend({
    template: 'panel/navbar',
    className: 'fixed',

    modelEvents: {
      'change': 'render'
    },

    behaviors: {
      Animateable: {
        types: ['fadeIn']
      }
    },

    initialize() {
      App.vent.on('rerender:topbar', () => this.render());
    },

    onShow() {
      this._reflow();
    },

    onRender() {
      this._reflow();
    },

    _reflow() {
      $(document).foundation('topbar', 'reflow');
    }
  });
});
