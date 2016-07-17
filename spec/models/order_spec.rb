# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:dishes) }
  it { should belong_to(:company) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:from) }
  it { should validate_presence_of(:company) }
  it do
    should validate_uniqueness_of(:from)
      .with_message('There already is an order from there today')
      .scoped_to(:date, :company_id)
  end
  it { should validate_length_of(:from).is_at_most(255) }

  let(:company) { create :company }
  let(:user) { create :user, company: company }

  it 'has statuses' do
    expect(described_class.statuses)
      .to eq('in_progress' => 0, 'ordered' => 1, 'delivered' => 2)
  end

  describe 'scopes' do
    let!(:order) { create :order, user: user, company: company }
    let!(:order2) do
      create :order, user: user, from: 'Another Place', company: company
    end
    let!(:order3) do
      create :order, user: user, date: 1.day.ago, company: company
    end

    describe '.today' do
      it "shows today's orders" do
        expect(described_class.today).to eq([order, order2])
      end
    end
    describe '.as_created' do
      it 'shows in creation order' do
        expect(described_class.as_created).to eq([order, order2, order3])
      end
    end
    describe '.newest_first' do
      it 'shows newest first' do
        expect(described_class.newest_first).to eq([order2, order, order3])
      end
    end
  end

  describe '#amount' do
    it 'returns 0 when no dishes' do
      order = described_class.new date: Time.zone.today
      expect(order).to receive(:dishes).and_return([])
      expected = Money.new(0, 'PLN')
      expect(order.amount).to eq(expected)
    end

    it 'returns 15 when there is a dish' do
      order = described_class.new date: Time.zone.today
      dish = instance_double('Dish')
      expect(dish).to receive(:price).and_return(Money.new(15, 'PLN'))
      expect(order).to receive(:dishes).and_return([dish])
      expect(order.amount).to eq(Money.new(15, 'PLN'))
    end
  end

  describe '#change_status' do
    let(:order) { create :order, user: user, company: company }
    context 'when in progress' do
      it 'changes from in_progress to ordered' do
        order.change_status(:ordered)
        expect(order.ordered?).to be_truthy
      end
      it 'does not substract price' do
        expect(order).not_to receive(:subtract_price)
        order.change_status(:ordered)
      end
      it 'does not allow changing from in progress to delivered' do
        order.change_status(:delivered)
        expect(order.in_progress?).to be_truthy
      end
    end
    context 'when ordered' do
      before { order.ordered! }
      it 'changes to delivered' do
        order.change_status(:delivered)
        expect(order.delivered?).to be_truthy
      end
      it 'substracts price' do
        expect(order).to receive(:subtract_price)
        order.change_status(:delivered)
      end
      it 'changes to in_progress' do
        order.change_status(:in_progress)
        expect(order.in_progress?).to be_truthy
      end
    end
    context 'when delivered' do
      it 'does not change to ordered' do
        order.delivered!
        order.change_status(:ordered)
        expect(order.delivered?).to be_truthy
      end
      it 'does not change to in_progress' do
        order.delivered!
        order.change_status('in_progress')
        expect(order.delivered?).to be_truthy
      end
    end
  end

  describe '#subtract_price' do
    let(:order) do
      create :order, user: user,
                     shipping: Money.new(2000, 'PLN'),
                     company: company
    end
    let(:dish1) { instance_double('Dish') }
    let(:dish2) { instance_double('Dish') }
    it 'iterates over dishes and call #subtract' do
      expect(dish1).to receive(:subtract).with(Money.new(1000, 'PLN'), user)
      expect(dish2).to receive(:subtract).with(Money.new(1000, 'PLN'), user)
      allow(order).to receive(:dishes_count).and_return(2)
      expect(order).to receive(:dishes).and_return([dish1, dish2])
      order.subtract_price
    end
  end
end
