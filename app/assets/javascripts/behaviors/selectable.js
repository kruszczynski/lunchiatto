window.Lunchiatto.Behaviors.Selectable = Marionette.Behavior.extend({
  ui: {
    select: 'select'
  },

  onShow() {
    this.ui.select.chosen({width: '100%'});
  }
});
