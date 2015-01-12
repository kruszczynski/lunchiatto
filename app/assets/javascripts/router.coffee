@CodequestManager.Router = Marionette.AppRouter.extend
  appRoutes:
    'dashboard(/)': 'dashboard'
    'finances(/)': 'finances'
    'orders(/)': 'ordersIndex'
    'orders/new(/)': 'newOrder'
    'orders/:orderId(/)': 'showOrder'
    'orders/:orderId/edit(/)': 'editOrder'
    'orders/:orderId/dishes/:dishId/edit(/)': 'editDish'
    'orders/:orderId/dishes/new(/)': 'newDish'
