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

  let!(:payment_one) do
    create :payment, user: user, payer: payer, balance: 15
  end
  let!(:payment_two) do
    create :payment, user: user, payer: payer, balance: 2
  end

  describe '#balances' do
    it 'returns adequate non-zero balances' do
      allow(user)
        .to receive(:company)
        .and_return(instance_double('Company', users: [user, payer]))
      balances = user.balances
      expect(balances.count).to be(1)
    end
  end

  describe '#add_first_balance' do
    let(:user) { described_class.new }
    let(:balances) { class_double('UserBalance') }

    it 'creates a user_balance' do
      allow(balances).to receive(:create)
      allow(user).to receive(:user_balances).and_return(balances)
      user.add_first_balance
      expect(balances).to have_received(:create).with(balance: 0, payer: user)
      expect(user).to have_received(:user_balances)
    end
  end

  describe '#subtract' do
    let(:money) { Money.new 1200, 'PLN' }
    it 'add a new reduced user balance' do
      allow(user).to receive(:payer_balance)
        .and_return(Money.new(5000, 'PLN'))
      expect { user.subtract(money, payer) }
        .to change(user.user_balances, :count).by(1)
      expect(user).to have_received(:payer_balance).with(payer)
    end

    it 'does not reduce when subtract_from_self is false' do
      allow(user).to receive(:subtract_from_self).and_return(false)
      allow(user).to receive(:payer_balance)
      expect { user.subtract(money, user) }
        .not_to change(user.user_balances, :count)
      expect(user).to have_received(:subtract_from_self)
      expect(user).not_to have_received(:payer_balance).with(user)
    end

    it 'does reduce when subtract_from_self is true' do
      allow(user).to receive(:payer_balance).and_return(Money.new(5000, 'PLN'))
      allow(user).to receive(:subtract_from_self).and_return(true)
      expect { user.subtract(money, user) }
        .to change(user.user_balances, :count).by(1)
      expect(user).to have_received(:payer_balance).with(user)
      expect(user).to have_received(:subtract_from_self)
    end
  end

  describe '#to_s' do
    it 'calls name' do
      expect(user.to_s).to eq('Bartek Szef')
    end
  end

  describe '#total_balance' do
    it 'returns proper balance' do
      money = Money.new(-1700, 'PLN')
      expect(user.total_balance).to eq(money)
    end
  end

  # TODO(anyone): deprecated method - remove
  describe '#total_debt' do
    it 'returns proper balance' do
      money = Money.new(-1700, 'PLN')
      expect(user.total_debt).to eq(money)
    end
  end

  describe '#debt_to and #payer_balance' do
    let(:user_2) { create :other_user, email: 'janek@yolo.com' }

    let!(:payment_three) do
      create(:payment, user: user_2, payer: payer, balance: 100)
    end

    it 'returns debt_to of user_2 and correct payer_balance of payer' do
      expect(user_2.debt_to(payer)).to eq(Money.new(-10_000, 'PLN'))
      expect(payer.payer_balance(user_2)).to eq(Money.new(10_000, 'PLN'))
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
