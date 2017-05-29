# frozen_string_literal: true
require 'rails_helper'

RSpec.describe WeeklyBalanceReminder do
  let(:company) { create :company }
  let(:user) { create :user, company: company }
  let(:other_user) { create :other_user, company: company }
  let!(:payment) do
    create :payment, user: user, payer: other_user, balance_cents: 30
  end
  let!(:payment2) do
    create :payment, user: user, payer: user, balance_cents: 30
  end
  let!(:transfer) do
    create :transfer, from: user, to: user, amount_cents: 30
  end
  let(:email) { instance_double('ActionMailer::Mail') }

  describe '#perform' do
    before do
      expect(BalanceMailer)
        .to receive(:debt_email)
        .with(user, [an_instance_of(Balance::Wrapper)])
        .and_return(email)
      expect(email).to receive(:deliver_now)
    end

    it 'sends email to the user' do
      subject.perform
    end
  end
end # describe WeeklyBalanceReminder
