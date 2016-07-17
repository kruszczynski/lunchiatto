# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserAuthorize::CreateUser do
  let(:company) { instance_double('Company') }
  let(:user) { instance_double('User') }
  let(:user_params) { instance_double('Hash') }
  let(:invitation) { instance_double('Invitation') }
  let(:info) { OpenStruct.new(email: 'test@codequest.com', name: 'Test Smith') }
  let(:omniauth_params) { instance_double('Omniauth::AuthHash', info: info) }
  subject do
    described_class.new omniauth_params: omniauth_params,
                        invitation: invitation
  end

  describe '#call' do
    context 'with existing user' do
      it 'returns when user is not nil' do
        subject.context.user = user
        expect(User).not_to receive(:new)
        subject.call
      end
    end
    context 'with invitation' do
      it 'performs' do
        expect(invitation).to receive(:email) { 'test@codequest.com' }
        expect(subject).to receive(:create_user) { user }
        subject.call
      end
      it "fails when invitation's email is different" do
        expect(invitation).to receive(:email) { 'sth-else@codequest.com' }
        # expect(subject).not_to receive(:user_params) { user_params }
        # expect(user).not_to receive(:save!)
        # expect(User).not_to receive(:new).with(user_params) { user }
        expect(subject).not_to receive(:create_user)
        expect { subject.call }.to raise_error(Interactor::Failure)
      end
    end
  end

  describe '#create_user' do
    it 'creates a user' do
      expect(subject).to receive(:user_params) { user_params }
      expect(user).to receive(:save!)
      expect(User).to receive(:new).with(user_params) { user }
      expect(subject.create_user).to eq(user)
    end
  end

  describe '#omniauth_params' do
    it 'delegates' do
      expect(subject.omniauth_params).to eq(omniauth_params)
    end
  end

  describe '#invitation' do
    it 'delegates' do
      expect(subject.invitation).to eq(invitation)
    end
  end

  describe '#user_params' do
    let(:expected) do
      {
        provider: 'google_oauth2',
        uid: '111111111111111111111',
        name: 'Test Smith',
        email: 'test@codequest.com',
        company: company,
      }
    end

    before do
      allow(omniauth_params).to receive(:info) { info }
      allow(omniauth_params).to receive(:provider) { 'google_oauth2' }
      allow(omniauth_params).to receive(:uid) { '111111111111111111111' }
      allow(invitation).to receive(:company) { company }
    end

    it 'parses' do
      expect(subject.user_params).to eq(expected)
    end
  end
end
