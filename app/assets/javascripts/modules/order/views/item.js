window.Lunchiatto.module('Order', function(Order, App, Backbone, Marionette, $, _) {
  return Order.Item = Marionette.ItemView.extend({
    template: 'orders/item',
    tagName: 'li',
    className: 'hover-pointer',

    triggers: {
      'click': 'show:order'
    },

    behaviors: {
      Animateable: {
        types: ['fadeIn']
      }
    },

    templateHelpers() {
      return {
        machineStatus: this.model.get('status').replace('_', '-'),
        humanStatus: this.model.get('status').replace('_', ' '),
      };
    },

    onShowOrder() {
      App.router.navigate(`/orders/${this.model.id}`, {trigger: true});
    }
  });
});
