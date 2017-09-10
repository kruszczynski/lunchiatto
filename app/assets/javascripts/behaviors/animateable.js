window.Lunchiatto.Behaviors.Animateable = Marionette.Behavior.extend({
  initialize(options) {
    if (!options.types) { return; }
    _.each(options.types, type => {
      this[type]();
    });
  },

  fadeIn() {
    this.view.className += ' animate__fade-in';
  }
});
