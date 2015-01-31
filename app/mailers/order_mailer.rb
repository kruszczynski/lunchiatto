class OrderMailer < ApplicationMailer
  def status_email(order)
    @order = order
    @payer = order.user
    mail(to: @payer.email, subject: "#{@payer}, mark today's order as delivered")
  end
end