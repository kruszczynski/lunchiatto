# frozen_string_literal: true
require 'rails_helper'

RSpec.describe WeeklyBalanceReminder do
  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let!(:payment) do
    create :payment, user: user, payer: other_user, balance_cents: 30
  end
  let!(:payment2) do
    create :payment, user: user, payer: other_user, balance_cents: 30
  end
  let!(:transfer) do
    create :transfer, from: other_user, to: user, amount_cents: 30
  end
  let(:email) { instance_double('ActionMailer::Mail') }

  describe '#perform' do
    before do
      allow(BalanceMailer).to receive(:debt_email).and_return(email)
      allow(email).to receive(:deliver_now)
    end

    it 'sends email to the user' do
      subject.perform
      expect(BalanceMailer)
        .to have_received(:debt_email)
        .with(user, [an_instance_of(Balance::Wrapper)])
      expect(email).to have_received(:deliver_now)
    end
  end
end # describe WeeklyBalanceReminder
