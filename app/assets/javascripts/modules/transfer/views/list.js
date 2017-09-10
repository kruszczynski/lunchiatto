window.Lunchiatto.module('Transfer', function(Transfer, App, Backbone, Marionette, $, _) {
  return Transfer.List = Marionette.CompositeView.extend({
    template: 'transfers/list',
    templateHelpers() {
      return {
        type: this.collection.type,
        usersForSelect: App.usersWithoutMe(),
        selectedUser: this.collection.userId
      };
    },
    getChildView() {
      return Transfer.Item;
    },
    getEmptyView() {
      return Transfer.Empty;
    },
    childViewContainer: '.transfers',
    childViewOptions() {
      return {type: this.collection.type};
    },

    behaviors: {
      Pageable: {},
      Selectable: {}
    },

    ui: {
      userSelect: '.user-id'
    },

    triggers: {
      'change @ui.userSelect': 'filter:transfers'
    },

    onFilterTransfers() {
      this.collection.userId = this.ui.userSelect.val();
      this.collection.page = 1;
      this.collection.optionedFetch({reset: true});
    }
  });
});
