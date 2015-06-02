require 'spec_helper'

describe Order, :type => :model do

  it { should belong_to(:user) }
  it { should have_many(:dishes) }
  it { should belong_to(:company) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:from) }
  it { should validate_presence_of(:company) }
  it { should validate_uniqueness_of(:from).with_message("There already is an order from there today").scoped_to(:company_id) }
  it { should validate_length_of(:from).is_at_most(255) }

  let(:company) { create :company }
  let(:user) { create :user, company: company }

  it 'should have statuses' do
    expect(Order.statuses).to eq({"in_progress"=>0, "ordered"=>1, "delivered"=>2})
  end

  describe "scopes" do
    let!(:order) { create :order, user: user, company: company }
    let!(:order2) { create :order, user: user, from: "Another Place", company: company }
    let!(:order3) { create :order, user: user, date: 1.day.ago, company: company }

    describe ".today" do
      it "shows today's orders" do
        expect(Order.today).to eq([order, order2])
      end
    end
    describe ".as_created" do
      it "shows in creation order" do
        expect(Order.as_created).to eq([order, order2, order3])
      end
    end
    describe ".newest_first" do
      it "shows newest first" do
        expect(Order.newest_first).to eq([order2, order, order3])
      end
    end
  end

  describe '#amount' do
    it 'should return 0 when no dishes' do
      order = Order.new date: Time.zone.today
      expect(order).to receive(:dishes).and_return([])
      expected = Money.new(0, 'PLN')
      expect(order.amount).to eq(expected)
    end

    it 'should return 15 when there is a dish' do
      order = Order.new date: Time.zone.today
      dish = double('Dish')
      expect(dish).to receive(:price).and_return(Money.new(15,'PLN'))
      expect(order).to receive(:dishes).and_return([dish])
      expect(order.amount).to eq(Money.new(15,'PLN'))
    end
  end

  describe '#change_status!' do
    let(:order) { create :order, user: user, company: company }
    it 'should change from in_progress to ordered' do
      expect(order).to_not receive(:subtract_price)
      order.change_status!
      expect(order.ordered?).to be_truthy
    end
    it 'should change from ordered to delivered' do
      order.ordered!
      order.save
      expect(order).to receive(:subtract_price)
      order.change_status!
      expect(order.delivered?).to be_truthy
    end
    it 'should not change further' do
      order.delivered!
      expect(order).to_not receive(:subtract_price)
      order.change_status!
      expect(order.delivered?).to be_truthy
    end
  end

  describe '#subtract_price' do
    let(:order) { create :order, user: user, shipping: Money.new(2000, 'PLN'), company: company }
    it 'should iterate over dishes and call #subtract' do
      dish1 = double('Dish')
      expect(dish1).to receive(:subtract).with(Money.new(1000, 'PLN'), user)
      dish2 = double('Dish')
      expect(dish2).to receive(:subtract).with(Money.new(1000, 'PLN'), user)
      allow(order).to receive(:dishes_count).and_return(2)
      expect(order).to receive(:dishes).and_return([dish1, dish2])
      order.subtract_price
    end
  end
end
