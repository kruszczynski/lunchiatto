window.Lunchiatto.module('Order', function(Order, App, Backbone, Marionette, $, _) {
  return Order.Dish = Marionette.ItemView.extend({
    OVERWRITE_MESSAGE: 'This might overwrite your current dish! Are you sure?',
    DELETE_MESSAGE: 'Are you sure?',
    template: 'orders/dish',
    tagName: 'li',
    className: 'dishes-list__item',

    ui: {
      copyButton: '.copy-link',
      deleteButton: '.delete-link'
    },

    triggers: {
      'click @ui.copyButton': 'copy:dish',
      'click @ui.deleteButton': 'delete:dish'
    },

    behaviors: {
      Animateable: {
        types: ['fadeIn']
      }
    },

    onCopyDish() {
      if (this._confirmOverwrite()) { this.model.copy(); }
    },

    onDeleteDish() {
      if (confirm(this.DELETE_MESSAGE)) {
        this.$el.addClass('animate__fade-out');
        setTimeout(() => {
          this.model.destroy();
        }
        , App.animationDurationMedium);
      }
    },

    serializeData() {
      return _.extend(this.model.toJSON(), {order: this.model.collection.order});
    },

    _confirmOverwrite() {
      return this.model.yetToOrder(App.currentUser) || confirm(this.OVERWRITE_MESSAGE);
    }
  });
});
