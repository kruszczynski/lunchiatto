# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:orders) }
  it { is_expected.to have_many(:submitted_transfers) }
  it { is_expected.to have_many(:received_transfers) }

  let(:user) { create(:user) }
  let(:payer) { create(:other_user) }

  let!(:payment_one) do
    create :payment, user: user, payer: payer, balance: 15
  end
  let!(:payment_two) do
    create :payment, user: user, payer: payer, balance: 2
  end

  describe '#balances' do
    it 'returns adequate non-zero balances' do
      balances = user.balances
      expect(balances.count).to be(1)
    end
  end

  describe '#subtract' do
    let(:money) { Money.new 1200, 'PLN' }

    it 'adds a new payment' do
      expect { user.subtract(money, payer) }
        .to change(user.received_payments, :count).by(1)
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
