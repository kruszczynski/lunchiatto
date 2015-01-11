@CodequestManager.Router = Marionette.AppRouter.extend
  appRoutes:
    'dashboard(/)': 'dashboard'
    'finances(/)': 'finances'
    'orders/:orderId/dishes/:dishId/edit': 'editDish'
    'orders/:orderId/dishes/new': 'newDish'