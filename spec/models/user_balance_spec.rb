# frozen_string_literal: true
require 'spec_helper'

describe UserBalance, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:payer) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:payer) }
  it 'monetizes balance' do
    expect(monetize(:balance_cents)).to be_truthy
  end

  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let!(:balance_one) do
    create :user_balance, user: user, payer: user, balance: 10
  end
  let!(:balance_two) do
    create :user_balance, user: user, payer: other_user, balance: 40
  end
  let!(:balance_three) do
    create :user_balance, user: user, payer: other_user, balance: 40
  end
  let!(:balance_four) do
    create :user_balance, user: user, payer: user, balance: 40
  end
  let!(:balance_five) do
    create :user_balance, user: other_user, payer: other_user, balance: 40
  end

  describe '.balances_for' do
    it 'calls adequate methods' do
      expect(described_class).to receive(:payers_ids).with(user)
        .and_return([user.id, other_user.id])
      expect(described_class.balances_for(user))
        .to contain_exactly(balance_four, balance_three)
    end
  end

  describe '.payers_ids' do
    it 'returns adequate ids' do
      expect(described_class.payers_ids(user))
        .to contain_exactly(other_user.id, user.id)
    end
  end

  describe '.debtors_ids' do
    it 'returns adequate ids' do
      expect(described_class.debtors_ids(user)).to contain_exactly(user.id)
    end
  end

  describe '.debts_to' do
    it 'calls adequate methods' do
      expect(described_class).to receive(:debtors_ids)
        .with(user).and_return([user.id])
      expect(described_class.debts_to(user)).to contain_exactly(balance_four)
    end
  end
end
