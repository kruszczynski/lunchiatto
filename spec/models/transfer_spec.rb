# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Transfer, type: :model do
  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let(:transfer) { create :transfer, from: user, to: other_user }

  it { is_expected.to belong_to(:from) }
  it { is_expected.to belong_to(:to) }
  it { is_expected.to validate_presence_of(:to) }
  it { is_expected.to validate_presence_of(:from) }

  it '#mark_as_rejected!' do
    expect { transfer.mark_as_rejected! }
      .to change { transfer.rejected? }
      .to(true)
  end

  describe '#mark_as_accepted!' do
    let(:user_balances) { class_double('UserBalance') }

    it 'creates new balance and change status' do
      expect(transfer).to receive(:accepted!)
      expect(user).to receive(:user_balances).and_return(user_balances)
      expect(user).to receive(:payer_balance).and_return(Money.new(500, 'PLN'))
      expect(user_balances).to receive(:create)
        .with(balance: Money.new(2000, 'PLN'), payer: other_user)
      transfer.mark_as_accepted!
    end
  end

  describe 'scope newest_first' do
    it 'orders appropriately' do
      expect(described_class).to receive(:order)
        .with('created_at desc').and_return(:sorted_and_created_at)
      expect(described_class.newest_first).to eq(:sorted_and_created_at)
    end
  end

  describe 'scope from_user' do
    it 'filters' do
      expect(described_class).to receive(:where).with(from_id: 7)
        .and_return(:from_filtered)
      expect(described_class.from_user(7)).to eq(:from_filtered)
    end
  end

  describe 'scope to_user' do
    it 'filters' do
      expect(described_class).to receive(:where).with(to_id: 17)
        .and_return(:to_filtered)
      expect(described_class.to_user(17)).to eq(:to_filtered)
    end
  end
end
