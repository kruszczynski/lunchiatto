# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Dish, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:order) }
  it { should validate_presence_of(:price_cents) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:order) }
  it do
    should validate_uniqueness_of(:user)
      .scoped_to(:order_id)
      .with_message('can only order one dish')
  end
  it { should validate_length_of(:name).is_at_most(255) }

  let(:company) { create :company }
  let(:user) { create :user, company: company }
  let(:other_user) { create :other_user, company: company }
  let(:order) { create :order, user: user, company: company }
  let!(:dish) { create :dish, user: user, order: order, price_cents: 1200 }
  let(:new_dish) { dish.copy(other_user) }

  it 'monetizes price' do
    expect(monetize(:price_cents)).to be_truthy
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
      expect(user).to receive(:subtract).with(Money.new(2200, 'PLN'), :payer)
      dish.subtract shipping, :payer
    end
  end
end
