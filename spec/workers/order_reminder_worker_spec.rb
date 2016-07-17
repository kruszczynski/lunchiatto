# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OrderReminderWorker do
  let(:order) { instance_double('Order') }
  let(:orders) { class_double('Order') }
  let(:email) { instance_double('ActionMailer::Mail') }

  describe '#perform' do
    before do
      expect(Order).to receive(:where).with(status: [0, 1]) { orders }
      expect(orders).to receive(:find_each).and_yield(order)
      expect(OrderMailer).to receive(:status_email).with(order) { email }
      expect(email).to receive(:deliver_now)
    end

    it 'sends email to all pending orders' do
      subject.perform
    end
  end
end # describe Workers::OrderReminder
