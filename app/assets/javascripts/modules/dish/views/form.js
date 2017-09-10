window.Lunchiatto.module('Dish', function(Dish, App, Backbone, Marionette, $, _) {
  Dish.Form = Marionette.ItemView.extend({
    template: 'dishes/form',

    ui: {
      priceInput: '.price',
      nameInput: '.name',
    },

    behaviors: {
      Errorable: {
        fields: ['name', 'price']
      },
      Submittable: {},
      Animateable: {
        types: ['fadeIn']
      },
      Titleable: {}
    },

    onFormSubmit() {
      this.model.save({
        name: this.ui.nameInput.val(),
        price: this.ui.priceInput.val().replace(',', '.')
      }, {
        success(model) {
          App.router.navigate(model.successPath(), {trigger: true});
        }
      }
      );
    },

    _htmlTitle() {
      if (this.model.get('id')) { return 'Edit Dish'; }
      return 'Add Dish';
    }
  });
});
