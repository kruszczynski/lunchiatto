# frozen_string_literal: true
require 'spec_helper'

describe UserAuthorize::FindInvitation do
  let(:user) { instance_double('User') }
  let(:invitation) { instance_double('Invitation') }
  let(:info) { OpenStruct.new(email: 'test@codequest.com', name: 'Test Smith') }
  let(:omniauth_params) { instance_double('Omniauth::AuthHash') }
  subject { described_class.new omniauth_params: omniauth_params }

  describe '#call' do
    it 'returns when user is not nil' do
      subject.context.user = user
      expect(Invitation).not_to receive(:find_by)
      subject.call
    end
    context 'when new user' do
      before do
        allow(omniauth_params).to receive(:info) { info }
      end

      it 'finds a invitation by email' do
        expect(Invitation).to receive(:find_by)
          .with(email: 'test@codequest.com', authorized: true) { invitation }
        subject.call
        expect(subject.context.invitation).to eq(invitation)
      end

      it 'fails when invitation is not found' do
        allow(Invitation).to receive(:find_by)
          .with(email: 'test@codequest.com', authorized: true) { nil }
        expect(subject.context).to receive(:fail!)
        subject.call
      end
    end
  end

  describe '#omniauth_params' do
    it 'delegates' do
      expect(subject.omniauth_params).to eq(omniauth_params)
    end
  end
end
