# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Dish, type: :model do
  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let(:order) { create :order, user: user }
  let!(:dish) { create :dish, user: user, order: order, price_cents: 1200 }
  let(:new_dish) { dish.copy(other_user) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:order) }
  it { is_expected.to validate_presence_of(:price_cents) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:order) }
  it do
    is_expected.to validate_uniqueness_of(:user)
      .scoped_to(:order_id)
      .with_message('can only order one dish')
  end
  it { is_expected.to validate_length_of(:name).is_at_most(255) }

  it 'monetizes price' do
    expect(monetize(:price_cents)).to be_truthy
  end

  it 'validates price positivity' do
    dish.price_cents = 0
    expect(dish.valid?).to be_truthy
    dish.price_cents = -100
    expect(dish.valid?).to be_falsey
  end

  describe '#copy' do
    it 'returns an instance of dish' do
      expect(new_dish.user).to eq(other_user)
      expect(new_dish.name).to eq(dish.name)
      expect(new_dish.order).to eq(order)
    end

    describe 'with existing dish' do
      let!(:existing_dish) { create :dish, user: other_user, order: order }
      it 'deletes existing dish first' do
        expect do
          dish.copy(other_user)
        end.to change(described_class, :count).by(-1)
      end
    end
  end

  describe '#subtract' do
    it 'reduces users balance' do
      shipping = Money.new(1000, 'PLN')
      allow(user).to receive(:subtract)
      dish.subtract shipping, other_user
      expect(user)
        .to have_received(:subtract)
        .with(Money.new(2200, 'PLN'), other_user)
    end
  end
end
