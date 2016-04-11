# frozen_string_literal: true
require 'spec_helper'

describe InvitationMailer, type: :mailer do
  describe '#created' do
    let(:company) { create :company }
    let(:user) { create :admin_user, company: company }
    let(:invitation) { create :invitation, company: company }
    subject { InvitationMailer.created(invitation) }

    it 'sends an email' do
      expect { subject.deliver_now }
        .to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'renders the subject' do
      expect(subject.subject).to eql('Join MyString on Lunchiatto')
    end

    it 'renders the receiver email' do
      expect(subject.to).to eql(['test@gmail.com'])
    end

    it 'renders the sender email' do
      expect(subject.from).to eql(['admin@lunchiatto.com'])
    end
  end
end
