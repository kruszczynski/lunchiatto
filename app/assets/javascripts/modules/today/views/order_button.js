window.Lunchiatto.module('Today', function(Today, App, Backbone, Marionette, $, _) {
  return Today.OrderButton = Marionette.ItemView.extend({
    template: 'today/order_button',
    tagName: 'span',

    ui: {
      button: '.button'
    },

    triggers: {
      'click @ui.button': 'select:order'
    },

    initialize(options) {
      this.model.set('current', options.current);
    },

    toggleActive(direction) {
      this.ui.button.toggleClass('secondary', !direction);
    }
  });
});
