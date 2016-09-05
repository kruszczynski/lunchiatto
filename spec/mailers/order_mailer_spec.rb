# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OrderMailer, type: :mailer do
  describe '#status_email' do
    let(:company) { create :company }
    let(:user) { create :user, company: company }
    let(:order) do
      create :order, user: user, from: 'The food place', company: company
    end
    let(:mail) { described_class.status_email(order) }

    it 'sends an email' do
      expect { mail.deliver_now }
        .to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'renders the subject' do
      expect(mail.subject)
        .to eql("Bartek Szef, mark today's order as delivered")
    end

    it 'renders the receiver email' do
      expect(mail.to[0]).to match(/bartek\d+@test.net/)
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['admin@lunchiatto.com'])
    end
  end
end
