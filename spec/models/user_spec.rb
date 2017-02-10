# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:orders) }
  it { is_expected.to have_many(:user_balances) }
  it { is_expected.to have_many(:balances_as_payer) }
  it { is_expected.to have_many(:submitted_transfers) }
  it { is_expected.to have_many(:received_transfers) }
  it { is_expected.to belong_to(:company) }
  it { is_expected.to callback(:add_first_balance).after(:create) }

  let(:user) { create(:user) }
  let(:payer) { create(:other_user) }
  let!(:balance_one) do
    create :user_balance, user: user, payer: payer, balance: 15
  end
  let!(:balance_two) do
    create :user_balance, user: user, payer: payer, balance: 17
  end
  let!(:balance_three) do
    create :user_balance, user: user, payer: user, balance: 34
  end

  describe '#balances' do
    it 'returns adequate' do
      expect(UserBalance).to receive(:balances_for)
        .with(user).and_return([balance_two, balance_three])
      balances = user.balances
      expect(balances.count).to be(2)
    end
  end

  describe '#add_first_balance' do
    let(:user) { described_class.new }
    let(:balances) { class_double('UserBalance') }

    it 'creates a user_balance' do
      expect(balances).to receive(:create).with(balance: 0, payer: user)
      expect(user).to receive(:user_balances).and_return(balances)
      user.add_first_balance
    end
  end

  describe '#subtract' do
    let(:money) { Money.new 1200, 'PLN' }
    it 'add a new reduced user balance' do
      expect(user).to receive(:payer_balance).with(payer)
        .and_return(Money.new(5000, 'PLN'))
      expect { user.subtract(money, payer) }
        .to change(user.user_balances, :count).by(1)
    end

    it 'doesnt reduce when subtract_from_self is false' do
      expect(user).to receive(:subtract_from_self).and_return(false)
      expect(user).not_to receive(:payer_balance).with(user)
      expect { user.subtract(money, user) }
        .not_to change(user.user_balances, :count)
    end

    it 'does reduce when subtract_from_self is true' do
      expect(user).to receive(:payer_balance)
        .with(user).and_return(Money.new(5000, 'PLN'))
      expect(user).to receive(:subtract_from_self).and_return(true)
      expect { user.subtract(money, user) }
        .to change(user.user_balances, :count).by(1)
    end
  end

  describe '#to_s' do
    it 'calls name' do
      expect(user).to receive(:name).and_return('mock name')
      expect(user.to_s).to eq('mock name')
    end
  end

  describe '#payer_balance' do
    let(:balance_payer) { instance_double('User') }
    let(:user_balances) { class_double('UserBalance') }
    let(:balance) { instance_double('UserBalance') }
    let(:newest_for_payer) { instance_double('UserBalance') }

    it 'calls scope method' do
      expect(balance_payer).to receive(:id).and_return(5)
      expect(newest_for_payer).to receive(:balance).and_return(balance)
      expect(user_balances).to receive(:newest_for).with(5)
        .and_return(newest_for_payer)
      expect(user).to receive(:user_balances).and_return(user_balances)
      expect(user.payer_balance(balance_payer)).to eq(balance)
    end
  end

  describe '#total_balance' do
    it 'returns proper balance' do
      money = Money.new 5100, 'PLN'
      expect(user.total_balance).to eq(money)
    end
  end

  describe '#debt_to' do
    let(:user_2) { create :other_user, email: 'janek@yolo.com' }
    let!(:balance_four) do
      create :user_balance, user: user_2, payer: payer, balance: 100
    end

    it 'returns debt of user_2' do
      expect(user_2.debt_to(payer)).to eq(Money.new(10_000, 'PLN'))
    end
  end

  describe '#debts' do
    it 'returns adequate' do
      expect(UserBalance).to receive(:debts_to).with(user).and_return(:debts)
      expect(user.debts).to be(:debts)
    end
  end

  describe '#total_debt' do
    it 'returns proper balance' do
      money = Money.new 3400, 'PLN'
      expect(user.total_debt).to eq(money)
    end
  end

  describe '#pending_transfers_count' do
    let!(:transfer_one) { create :transfer, from: user, to: payer }
    let!(:transfer_two) { create :transfer, from: payer, to: user }
    it 'returns adequate count' do
      expect(user.pending_transfers_count).to eq(1)
    end
  end

  describe 'admin scope' do
    let(:admin) { create :user, admin: true, email: 'admin@adminbook.com' }
    before do
      user
      payer
      admin
    end
    it 'Only returns admin' do
      expect(described_class.admin.count).to be(1)
    end
  end
end
