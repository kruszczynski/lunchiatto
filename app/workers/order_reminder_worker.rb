class OrderReminderWorker
  include Sidekiq::Worker

  def perform
    statuses = [Order.statuses[:in_progress], Order.statuses[:ordered]]
    Order.where(status: statuses).find_each do |order|
      OrderMailer.status_email(order).deliver_now
    end
  end
end # class OrderReminderWorker
