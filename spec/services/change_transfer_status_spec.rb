# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ChangeTransferStatus do
  include ActiveJob::TestHelper
  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let(:transfer) { create :transfer, from: user, to: other_user }
  let(:accepted_transfer) do
    create :transfer, from: user, to: other_user, status: :accepted
  end

  let(:service) { described_class.new transfer, user }
  let(:other_user_service) { described_class.new transfer, other_user }
  let(:accepted_transfer_service) do
    described_class.new accepted_transfer, other_user
  end

  it 'initializes' do
    expect(service.transfer).to be(transfer)
    expect(service.user).to be(user)
  end

  describe '#perform' do
    describe 'accepts' do
      it 'enqueues acception email' do
        expect { service.perform(:accepted) }
          .to change(enqueued_jobs, :count).by(1)
      end
      it 'changes status' do
        service.perform(:accepted)
        expect(transfer.status).to eq('accepted')
      end
      it 'returns true' do
        expect(service.perform(:accepted))
      end
    end
    describe 'rejects' do
      it 'enqueues rejection email' do
        expect { service.perform(:rejected) }
          .to change(enqueued_jobs, :count).by(1)
      end
      it 'changes status' do
        service.perform(:rejected)
        expect(transfer.status).to eq('rejected')
      end
      it 'returns true' do
        expect(service.perform(:rejected))
      end
    end
  end
end
