window.Lunchiatto.Behaviors.Submittable = Marionette.Behavior.extend({
  ui: {
    form: 'form',
    submitButton: "[type='submit']"
  },

  triggers: {
    'submit @ui.form': 'form:submit'
  },

  onShow() {
    this.listenTo(this.view.model, 'error', this._enableSubmit, this);
    this.listenTo(this.view.model, 'sync', this._enableSubmit, this);
    if (!this.view.model.id) { this._focusFistInput(); }
  },

  onFormSubmit() {
    this.ui.submitButton.prop('disabled', true);
  },

  _focusFistInput() {
    this.ui.form.find('input:first').focus();
  },

  _enableSubmit() {
    this.ui.submitButton.prop('disabled', false);
  }
});
