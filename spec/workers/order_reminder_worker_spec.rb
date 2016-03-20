require 'spec_helper'

describe OrderReminderWorker do
  let(:order) { double('order') }
  let(:orders) { double('orders_collection')}
  let(:mailer) { double('mailer') }

  describe '#perform' do
    it 'sends email to all pending orders' do
      expect(Order).to receive(:where).with(status: [0, 1]) { orders }
      expect(orders).to receive(:find_each).and_yield(order)
      expect(OrderMailer).to receive(:status_email).with(order) { mailer }
      expect(mailer).to receive(:deliver_now)
      subject.perform
    end
  end
end # describe Workers::OrderReminder
