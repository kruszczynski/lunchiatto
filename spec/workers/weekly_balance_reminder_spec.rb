require 'spec_helper'

describe WeeklyBalanceReminder do
  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let!(:user_balance) do
    create :user_balance, user: user, payer: other_user, balance_cents: -30
  end
  let!(:user_balance2) do
    create :user_balance, user: user, payer: user, balance_cents: -30
  end
  let!(:transfer) do
    create :transfer, from: user, to: user, amount_cents: 30
  end
  let(:mailer) { double('BalanceMailer') }

  describe '#perform' do
    it 'sends email to the user' do
      expect(BalanceMailer)
        .to receive(:debt_email)
        .with(user, [user_balance])
        .and_return(mailer)
      expect(mailer).to receive(:deliver_now)
      subject.perform
    end
  end
end # describe WeeklyBalanceReminder
