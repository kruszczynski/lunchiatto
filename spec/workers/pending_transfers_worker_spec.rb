require 'spec_helper'

describe PendingTransfersWorker do
  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let(:mailer) { double('TransferMailer') }
  let!(:transfer) do
    create :transfer, from: other_user, to: user, created_at: 5.days.ago
  end
  let!(:transfer2) do
    create :transfer, from: other_user, to: user
  end

  describe '#perform' do
    it 'sends pending transfers email' do
      expect(TransferMailer)
        .to receive(:pending_transfers)
        .with([transfer], user)
        .and_return(mailer)
      expect(mailer).to receive(:deliver_now)
      subject.perform
    end
  end # describe '#perform'
end # describe PendingTransfersWorker
