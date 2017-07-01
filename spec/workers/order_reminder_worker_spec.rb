# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OrderReminderWorker do
  let!(:order) { create(:order, user: build(:user)) }
  let(:email) { instance_double('ActionMailer::Mail') }

  describe '#perform' do
    before do
      allow(OrderMailer).to receive(:status_email) { email }
      allow(email).to receive(:deliver_now)
    end

    it 'sends email to all pending orders' do
      subject.perform
      expect(OrderMailer).to have_received(:status_email).with(order)
      expect(email).to have_received(:deliver_now)
    end
  end
end # describe Workers::OrderReminder
