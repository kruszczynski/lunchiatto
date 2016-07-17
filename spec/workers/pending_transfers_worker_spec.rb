# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PendingTransfersWorker do
  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let(:email) { instance_double('ActionMailer::Mail') }
  let!(:transfer) do
    create :transfer, from: other_user, to: user, created_at: 5.days.ago
  end
  let!(:transfer2) do
    create :transfer, from: other_user, to: user
  end

  describe '#perform' do
    before do
      expect(TransferMailer)
        .to receive(:pending_transfers)
        .with([transfer], user)
        .and_return(email)
      expect(email).to receive(:deliver_now)
    end

    it 'sends pending transfers email' do
      subject.perform
    end
  end # describe '#perform'
end # describe PendingTransfersWorker
