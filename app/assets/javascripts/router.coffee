@CodequestManager.Router = Marionette.AppRouter.extend
  appRoutes:
    "dashboard(/)": "dashboard"
    "balances(/)": "balancesIndex"
    "orders(/)": "ordersIndex"
    "orders/new(/)": "newOrder"
    "orders/:orderId(/)": "showOrder"
    "orders/:orderId/edit(/)": "editOrder"
    "orders/:orderId/dishes/:dishId/edit(/)": "editDish"
    "orders/:orderId/dishes/new(/)": "newDish"
    "account_numbers(/)": "accountNumbers"
    "settings(/)": "settings"
    "transfers(/)": "transfersIndex"
    "transfers/new(/)": "newTransfer"
