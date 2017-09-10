window.Lunchiatto.Behaviors.Titleable = Marionette.Behavior.extend({
  // calls view._htmlTitle() on a view to set returned value as title
  onShow() {
    Lunchiatto.vent.trigger(
      'set:html:title',
      `${this.view._htmlTitle()} | Lunchiatto`
    );
  }
});
