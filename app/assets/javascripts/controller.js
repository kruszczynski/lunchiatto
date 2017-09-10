(function(App) {
  const forLoggedInOnly = function() {
    if (App.currentUser.loggedIn()) { return false; }
    App.router.navigate('/', {trigger: true});
    return true;
  };

  const maybeRedirectToToday = function() {
    if (!App.currentUser.loggedIn()) { return false; }
    App.router.navigate('/orders/today', {trigger: true});
    return true;
  };

  return App.Controller = {
    pageIndex() {
      if (maybeRedirectToToday()) { return; }
      App.Page.Controller.index();
    },

    showInvitation(invitationId) {
      if (maybeRedirectToToday()) { return; }
      const invitation = new App.Entities.Invitation({id: invitationId});
      invitation.fetch({
        success(invitation) {
          App.User.Controller.show(invitation);
        }
      });
    },

    ordersToday(orderId) {
      if (forLoggedInOnly()) { return; }
      App.Today.Controller.today(orderId);
    },

    editDish(orderId, dishId) {
      if (forLoggedInOnly()) { return; }
      const dish = new App.Entities.Dish({order_id: orderId, id: dishId});
      dish.fetch({
        success(dish) {
          App.Dish.Controller.form(dish);
        }
      });
    },

    newDish(orderId) {
      if (forLoggedInOnly()) { return; }
      const dish = new App.Entities.Dish({
        order_id: orderId,
        user_id: App.currentUser.id,
        price: '0.00'
      });
      App.Dish.Controller.form(dish);
    },

    newOrder() {
      if (forLoggedInOnly()) { return; }
      const order = new App.Entities.Order({shipping: '0.00'});
      App.Order.Controller.form(order);
    },

    showOrder(orderId) {
      if (forLoggedInOnly()) { return; }
      const order = new App.Entities.Order({id: orderId});
      order.fetch({
        success(order) {
          App.Order.Controller.show(order);
        }
      });
    },

    editOrder(orderId) {
      if (forLoggedInOnly()) { return; }
      const order = new App.Entities.Order({id: orderId});
      order.fetch({
        success(order) {
          App.Order.Controller.form(order);
        }
      });
    },

    ordersIndex() {
      if (forLoggedInOnly()) { return; }
      const orders = new App.Entities.Orders;
      orders.fetch({
        success(orders) {
          App.Order.Controller.list(orders);
        }
      });
    },

    yourBalances() {
      if (forLoggedInOnly()) { return; }
      App.Balance.Controller.you();
    },

    othersBalances() {
      if (forLoggedInOnly()) { return; }
      App.Balance.Controller.others();
    },

    accountNumbers() {
      if (forLoggedInOnly()) { return; }
      App.Dashboard.Controller.accounts();
    },

    settings() {
      if (forLoggedInOnly()) { return; }
      return App.currentUser.fetch({
        success(user) {
          return App.Dashboard.Controller.settings(user);
        }
      });
    },

    transfersIndex() {
      if (forLoggedInOnly()) { return; }
      return App.Transfer.Controller.index();
    },

    newTransfer() {
      if (forLoggedInOnly()) { return; }
      return App.Transfer.Controller.form();
    },

    members() {
      if (forLoggedInOnly()) { return; }
      return App.User.Controller.members();
    }
  };
})(this.Lunchiatto);
