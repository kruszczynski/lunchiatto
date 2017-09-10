window.Lunchiatto.module('Order', function(Order, App, Backbone, Marionette, $, _) {
  return Order.Form = Marionette.ItemView.extend({
    template: 'orders/form',

    ui: {
      userSelect: '.user-id',
      restaurantInput: '.from',
      shipping: '.shipping',
    },

    behaviors: {
      Errorable: {
        fields: ['user', 'from', 'shipping']
      },
      Submittable: {},
      Animateable: {
        types: ['fadeIn']
      },
      Titleable: {},
      Selectable: {}
    },

    onFormSubmit() {
      this.model.save({
        user_id: this.ui.userSelect.val(),
        from: this.ui.restaurantInput.val(),
        shipping: this.ui.shipping.val()
      }, {
        success(model) {
          App.router.navigate(model.successPath(), {trigger: true});
        }
      });
    },

    _htmlTitle() {
      if (this.model.get('id')) { return 'Edit Order'; }
      return 'Add Order';
    }
  });
});
