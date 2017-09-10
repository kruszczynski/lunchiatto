window.Lunchiatto.Behaviors.Pageable = Marionette.Behavior.extend({
  ui: {
    more: '.more'
  },

  triggers: {
    'click @ui.more': 'fetch:more'
  },

  onShow() {
    this._collectionReset();
    this.view.collection.on('all:fetched', this._hideMore, this);
    this.view.collection.on('reset', this._collectionReset, this);
  },

  onFetchMore() {
    this.view.collection.more();
  },

  _hideMore() {
    this.ui.more.addClass('hide');
  },

  _collectionReset() {
    this.ui.more.toggleClass('hide', this.view.collection.length < Lunchiatto.pageSize);
  }
});
