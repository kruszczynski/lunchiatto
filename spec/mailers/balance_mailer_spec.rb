# frozen_string_literal: true
require 'spec_helper'

describe BalanceMailer, type: :mailer do
  describe '#debt_email' do
    let(:user) { create :user }
    let(:other_user) { create :other_user }
    let(:balance_one) do
      create :user_balance, user: user, payer: user, balance: 10
    end
    let(:balance_two) do
      create :user_balance, user: user, payer: other_user, balance: 40
    end
    let(:balances) { [balance_one, balance_two] }
    let(:mail) { BalanceMailer.debt_email(user, balances) }

    it 'sends an email' do
      expect { mail.deliver_now }
        .to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'renders the subject' do
      expect(mail.subject).to eql('Bartek Szef you owe people money!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql(['bartek@test.net'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['admin@lunchiatto.com'])
    end
  end
end
