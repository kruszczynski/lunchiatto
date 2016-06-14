# frozen_string_literal: true
require 'spec_helper'

describe UserAuthorize::FindByUid do
  let(:user) { instance_double('User') }
  let(:omniauth_params) { {} }
  subject { described_class.new omniauth_params: omniauth_params }

  describe '#call' do
    before do
      omniauth_params[:provider] = 'google_oauth2'
      omniauth_params[:uid] = '111111111111111111111'
    end

    it 'finds the user by uuid' do
      expect(User).to receive(:find_by).with(omniauth_params) { user }
      subject.call
      expect(subject.context[:user]).to eq(user)
    end
  end
end
