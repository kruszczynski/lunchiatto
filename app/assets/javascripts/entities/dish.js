window.Lunchiatto.module('Entities', function(Entities, App, Backbone, Marionette, $, _) {
  Entities.Dish = Backbone.Model.extend({
    copyUrl() {
      return `/api/orders/${this.get('order_id')}/dishes/${this.id}/copy`;
    },

    urlRoot() {
      return `/api/orders/${this.get('order_id')}/dishes`;
    },

    copy() {
      $.ajax({
        url: this.copyUrl(),
        type: 'POST',
        success: data => {
          const copiedDish = new Entities.Dish(data);
          const currentDish = this.collection.where({user_id: data.user_id});
          this.collection.remove(currentDish);
          this.collection.add(copiedDish);
        }
      });
    },

    yetToOrder(user) {
      return this.collection.where({user_id: user.id}).length === 0;
    },

    successPath() {
      if (this.get('from_today')) {
        return `/orders/today/${this.get('order_id')}`;
      } else {
        return `/orders/${this.get('order_id')}`;
      }
    }
  });

  return Entities.Dishes = Backbone.Collection.extend({
    model: Entities.Dish,

    total() {
      return this.reduce((memo, debt) => memo + parseFloat(debt.get('price')), 0);
    }
  });
});
