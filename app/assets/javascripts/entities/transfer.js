window.Lunchiatto.module('Entities', function(Entities, App, Backbone, Marionette, $, _) {
  Entities.Transfer = Backbone.Model.extend({
    urlRoot() {
      return '/api/transfers';
    },

    accept() {
      $.ajax({
        type: 'PUT',
        url: `${this.url()}/accept`,
        success: data => this.set(data),
      });
    },

    reject() {
      $.ajax({
        type: 'PUT',
        url: `${this.url()}/reject`,
        success: data => this.set(data),
      });
    }
  });


  return Entities.Transfers = Backbone.Collection.extend({
    model: Entities.Transfer,
    url() {
      return '/api/transfers';
    },

    initialize(models, options){
      this.type = options.type;
    },

    page: 1,
    userId: '',

    more() {
      this.page += 1;
      this.fetch({
        data: this._getData(),
        remove: false,
        success: (collection, data) => {
          if(data.length < App.pageSize) {
            this.trigger('all:fetched');
          }
        },
      });
    },

    optionedFetch(options) {
      const extendedOptions = _.extend({data: this._getData()}, options);
      Backbone.Collection.prototype.fetch.call(this, extendedOptions);
    },

    _getData() {
      return {page: this.page, user_id: this.userId, type: this.type};
    }});
});
