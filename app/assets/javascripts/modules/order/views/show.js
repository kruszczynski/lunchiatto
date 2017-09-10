window.Lunchiatto.module('Order', function(Order, App, Backbone, Marionette, $, _) {
  return Order.Show = Marionette.LayoutView.extend({
    DELETE_MESSAGE: `This will permanently delete the order and \
ALL THE DISHES. Are you sure?`,
    template: 'orders/show',

    ui: {
      dishesSection: '.dishes-section',
      orderButton: '.order-button',
      changeStatus: '.change-status-button',
      revertStatus: '.revert-status-button',
      deleteOrder: '.destroy-order-button',
      orderTotal: '.title-total'
    },

    regions: {
      dishes: '@ui.dishesSection'
    },

    triggers: {
      'click @ui.changeStatus': 'change:status',
      'click @ui.revertStatus': 'revert:status',
      'click @ui.deleteOrder': 'delete:order'
    },

    behaviors: {
      Animateable: {
        types: ['fadeIn']
      },
      Titleable: {}
    },

    modelEvents: {
      'change': 'render'
    },

    templateHelpers() {
      return {
        machineStatus: this.model.get('status').replace('_', '-'),
        humanStatus: this.model.get('status').replace('_', ' ')
      };
    },

    initialize() {
      this.listenTo(this.model.get('dishes'), 'add remove', this._hideOrderButton);
      this.listenTo(this.model.get('dishes'), 'add remove', this._recalculateTotal);
    },

    onRender() {
      this._showDishes();
      this._hideOrderButton();
    },

    onChangeStatus() {
      this.model.changeStatus();
    },

    onRevertStatus() {
      this.model.revertStatus();
    },

    onDeleteOrder() {
      if (confirm(this.DELETE_MESSAGE)) {
        this.model.destroy({
          success() {
            App.router.navigate('/orders/today', {trigger: true});
          }
        });
      }
    },

    _showDishes() {
      const dishes = new Order.Dishes({
        collection: this.model.get('dishes'),
      });
      this.dishes.show(dishes);
    },

    _hideOrderButton() {
      this.ui.orderButton.toggleClass('hide', this.model.currentUserOrdered());
    },

    _recalculateTotal() {
      this.ui.orderTotal.text(this.model.total());
    },

    _htmlTitle() {
      return this.model.get('from');
    }
  });
});
