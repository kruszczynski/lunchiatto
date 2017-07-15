# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AuthorizeUser::FindInvitation do
  let(:invitation_email) { 'test@codequest.com' }
  let!(:invitation) { create(:invitation, email: invitation_email) }
  let(:info) { OpenStruct.new(email: 'test@codequest.com', name: 'Test Smith') }
  let(:omniauth_params) { instance_double('Omniauth::AuthHash', info: info) }
  let(:context) { Pipes::Context.new(omniauth_params: omniauth_params) }
  subject { described_class.call(context) }

  describe '#call' do
    context 'with invitation' do
      it 'finds a invitation by email' do
        subject
        expect(context.invitation).to eq(invitation)
      end
    end # context 'with invitation'
    context 'when invitation not found' do
      let(:invitation_email) { 'dupa@kopa.com' }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end # context 'when invitation not found'
  end # describe '#call'
end # RSpec.describe AuthorizeUser::FindInvitation
