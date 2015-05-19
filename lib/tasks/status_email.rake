namespace :status_email do
  task send: :environment do
    statuses = [Order.statuses[:in_progress], Order.statuses[:ordered]]
    orders = Order.where(status: statuses)
    orders.find_each do |order|
      OrderMailer.status_email(order).deliver_now
    end
  end
end
