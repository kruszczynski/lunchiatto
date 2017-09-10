window.Lunchiatto.module('Today', function(Today, App, Backbone, Marionette, $, _) {
  return Today.Layout = Marionette.LayoutView.extend({
    template: 'today/layout',

    regions: {
      orderButtons: '.order-buttons',
      order: '.order'
    },

    behaviors: {
      Animateable: {
        types: ['fadeIn']
      }
    },

    initialize(options) {
      this.currentOrder = options.order;
    },

    onRender() {
      this._showButtons();
      if (this.currentOrder) {
        this.showOrder(this.currentOrder);
      } else {
        this._navigateToToday();
      }
    },

    showOrder(order) {
      App.router.navigate(`/orders/today/${order.id}`);
      order = new App.Entities.Order({id: order.id});
      order.fetch({
        success: order => {
          this.buttons.currentOrder(order.id);
          const view = new App.Order.Show({model: order});
          this.order.show(view);
        }
      });
    },

    _showButtons() {
      this.buttons = new Today.OrderButtons({collection: this.collection});
      this.buttons.on(
        'childview:select:order',
        orderView => this.showOrder(orderView.model),
      );
      this.orderButtons.show(this.buttons);
    },

    _navigateToToday() {
      App.router.navigate('/orders/today');
    }
  });
});
