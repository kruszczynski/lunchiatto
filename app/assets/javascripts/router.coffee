@CodequestManager.Router = Marionette.AppRouter.extend
  appRoutes:
    'dashboard(/)': 'dashboard'
    'finances(/)': 'finances'
    'orders(/)': 'ordersIndex'
    'orders/new(/)': 'newOrder'
    'orders/:orderId(/)': 'showOrder'
    'orders/:orderId/edit(/)': 'editOrder'
    'orders/:orderId/shipping(/)': 'orderShipping'
    'orders/:orderId/dishes/:dishId/edit(/)': 'editDish'
    'orders/:orderId/dishes/new(/)': 'newDish'
    'account_numbers(/)': 'accountNumbers'
    'settings(/)': 'settings'
    'transfers/new(/)': 'newTransfer'
