namespace :status_email do
  task send: :environment do
    order = Order.todays_order
    exit if order.nil? || order.delivered?
    OrderMailer.status_email(order).deliver_now
  end
end