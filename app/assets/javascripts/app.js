window.Lunchiatto = (function(Backbone, Marionette) {
  Marionette.Renderer.oldRender = Marionette.Renderer.render;
  Marionette.Renderer.render = function(template, data) {
    if (typeof template === 'function') { template = template(); }

    if (!JST[template]) {
      return Marionette.Renderer.oldRender(template, data);
    }
    return JST[template](data);
  };

  const App = new Marionette.Application();

  App.Behaviors = {};

  App.currentUser = undefined;

  App.pageSize = 10;
  App.animationDurationMedium = 500;

  App.usersWithoutMe = () => _.reject(gon.usersForSelect, user => user.id === App.currentUser.id);

  App.on('start', function() {
    const $title = $('head title');
    App.router = new App.Router({controller: App.Controller});

    App.root = new App.Root.Layout;

    Marionette.Behaviors.behaviorsLookup = () => App.Behaviors;
    App.currentUser = new App.Entities.User(gon.currentUser);
    App.vent.on('reload:current:user', () => App.currentUser.fetch());
    App.vent.on('set:html:title', title => $title.text(title));

    $(document).foundation();
    if (App.currentUser.loggedIn()) {
      App.Panel.Controller.showNavbar();
    }

    Backbone.history.start({
      pushState: true});

    const menuIcon = $('.menu-icon');
    const navigation = $('.top-bar');

    $('body').on('click', '[data-navigate]', function(e) {
      if (e.metaKey) { return; }
      e.preventDefault();
      $title.text('Lunchiatto');
      const href = $(e.currentTarget).attr('href');
      App.router.navigate(href, {trigger: true});
      if (navigation.hasClass('expanded')) { menuIcon.click(); }
      return navigation.click();
    });
  });
  return App;
})(Backbone, Marionette);

$(() => Lunchiatto.start());
