window.Lunchiatto.Behaviors.Errorable = Marionette.Behavior.extend({
  ui: {
    errorMessages: 'small.error',
    fullError: '.full-error',
    fullErrorParagraph: '.full-error p'
  },

  initialize(options) {
    this.fields = options.fields;
    _.each(options.fields, field => {
      this.ui[`${field}Label`] = `.${field}-label`;
    });
  },

  onShow() {
    this.listenTo(this.view.model, 'error', this.onModelError, this);
    this.listenTo(this.view.model, 'sync', this.hideErrors, this);
  },

  onModelError(model, data) {
    this.hideErrors();
    if (data && data.responseJSON) {
      let message = '';
      _.each(data.responseJSON.errors, (errors, key)=> {
        if (_.contains(this.fields, key)) {
          this._showError(errors, key);
        } else {
          if (key === 'date') {
            message += Humanize.capitalize(`${errors.join(', ')}!`);
          } else {
            message += Humanize.capitalize(`${key} ${errors.join(', ')}!`);
          }
          message += '<br/>';
        }
      });
      if (message) { this._showFulError(message); }
    }
  },

  hideErrors() {
    this.ui.fullErrorParagraph.empty();
    this.ui.fullError.addClass('hide');
    this.ui.errorMessages.addClass('hide');
    _.each(this.fields, field => {
      this.ui[`${field}Label`].removeClass('error');
    });
  },

  _showError(errors, key) {
    const label = this.ui[`${key}Label`];
    label.addClass('error');
    label.find('.error').removeClass('hide')
      .text(`\"${key}\" ${errors.join(', ')}`);
  },

  _showFulError(message) {
    this.ui.fullError.removeClass('hide');
    this.ui.fullErrorParagraph.html(message);
  }
});
