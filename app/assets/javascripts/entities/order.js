window.Lunchiatto.module('Entities', function(Entities, App, Backbone, Marionette, $, _) {
  Entities.Order = Backbone.Model.extend({
    STATUSES: ['in_progress', 'ordered', 'delivered'],

    urlRoot() {
      return '/api/orders';
    },

    parse(data) {
      data.dishes = new Entities.Dishes(data.dishes);
      data.dishes.order = this;
      return data;
    },

    currentUserOrdered() {
      return this.get('dishes').where({user_id: App.currentUser.id}).length !== 0;
    },

    changeStatus() {
      this._updateStatus(this._nextStatus());
    },

    revertStatus() {
      this._updateStatus(this._prevStatus());
    },

    total() {
      return (this.get('dishes').total() + parseFloat(this.get('shipping'))).toFixed(2);
    },

    successPath() {
      if (this.get('from_today')) {
        return `/orders/today/${this.id}`;
      } else {
        return `/orders/${this.id}`;
      }
    },

    _updateStatus(newStatus) {
      $.ajax({
        type: 'PUT',
        url: `${this.url()}/change_status`,
        data: {
          status: newStatus
        },
        success: data => {
          this.set(this.parse(data));
          if(data.status === 'delivered') {
            App.vent.trigger('reload:current:user');
          }
        }
      });
    },

    _nextStatus() {
      return this.STATUSES[Math.min(2, this._statusInt()+1)];
    },
    _prevStatus() {
      return this.STATUSES[Math.max(0, this._statusInt()-1)];
    },

    _statusInt() {
      return this.STATUSES.indexOf(this.get('status'));
    }
  });


  Entities.Orders = Backbone.Collection.extend({
    model: Entities.Order,
    url: '/api/orders',

    page: 1,

    more() {
      this.page += 1;
      this.fetch({
        data: {
          page: this.page
        },
        remove: false,
        success: (collection, data) => {
          if(data.length < App.pageSize) {
            this.trigger('all:fetched');
          }
        }
      });
    }
  });
});
