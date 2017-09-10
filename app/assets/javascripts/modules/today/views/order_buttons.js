window.Lunchiatto.module('Today', function(Today, App, Backbone, Marionette, $, _) {
  return Today.OrderButtons = Marionette.CompositeView.extend({
    template: 'today/order_buttons',
    childViewContainer: '.buttons-container',

    getChildView() {
      return Today.OrderButton;
    },

    currentOrder(orderId) {
      this.children.each(child => child.toggleActive(child.model.id === orderId));
    }
  });
});
