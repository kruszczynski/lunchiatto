# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AuthorizeUser::CreateUser do
  let(:company) { create(:company) }
  let(:invited_email) { 'test@lunchiatto.com' }
  let(:invitation) do
    create(:invitation, email: invited_email, company: company)
  end
  let(:info) { OpenStruct.new(email: 'test@lunchiatto.com', name: 'Ted Smith') }
  let(:omniauth_params) do
    instance_double(
      'Omniauth::AuthHash',
      info: info,
      uid: 123,
      provider: 'google_oauth2',
    )
  end
  let(:context) do
    Pipes::Context.new(omniauth_params: omniauth_params, invitation: invitation)
  end
  subject { described_class.call(context) }

  describe '#call' do
    context 'when email are different' do
      let(:invited_email) { 'sth-else@lunchiatto.com' }

      it 'raises AuthorizeUser::EmailMismatch' do
        expect { subject }.to raise_error(AuthorizeUser::EmailMismatch)
      end

      # rubocop:disable Style/RescueModifier, Lint/AmbiguousBlockAssociation
      it 'does not create a user' do
        expect { subject rescue nil }
          .not_to change { User.count }
      end
      # rubocop:enable Style/RescueModifier, Lint/AmbiguousBlockAssociation
    end # context 'when email are different'

    context 'when emails match' do
      let(:user) { context.user }
      it 'assigns name' do
        subject
        expect(user.name).to eq('Ted Smith')
      end

      it 'assigns email' do
        subject
        expect(user.email).to eq('test@lunchiatto.com')
      end

      it 'assigns uid' do
        subject
        expect(user.uid).to eq('123')
      end

      it 'assigns oauth provider' do
        subject
        expect(user.provider).to eq('google_oauth2')
      end

      it 'assigns to company' do
        subject
        expect(company.users).to include(context.user)
      end

      it 'creates one user' do
        expect { subject }.to change { User.count }.by(1)
      end
    end # context 'when emails match'
  end # describe '#call'
end # RSpec.describe AuthorizeUser
