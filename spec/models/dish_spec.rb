require 'spec_helper'

describe Dish, :type => :model do
  it {should belong_to(:user)}
  it {should belong_to(:order)}
  it {should validate_numericality_of(:price_cents)}
  it {should validate_presence_of(:price_cents)}
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:user)}
  it {should validate_presence_of(:order)}
  it {should validate_uniqueness_of(:user).scoped_to(:order_id).with_message('can only order one dish')}

  let(:user) {create :user}
  let(:other_user) {create :other_user}
  let(:order) {create :order, user: user}
  let!(:dish) {create :dish, user: user, order: order, price_cents: 1200}

  it 'should monetize price' do
    expect(monetize(:price_cents)).to be_truthy
  end

  describe '#copy' do
    it 'should return an instance of dish' do
      @new_dish = dish.copy(other_user)
      expect(@new_dish.user).to eq(other_user)
      expect(@new_dish.name).to eq(dish.name)
      expect(@new_dish.order).to eq(order)
    end

    describe 'with existing dish' do
      let!(:existing_dish) {create :dish, user: other_user, order: order}
      it 'should delete existing dish first' do
        expect {
          dish.copy(other_user)
        }.to change(Dish, :count).by(-1)
      end
    end
  end

  describe '#subtract' do
    it 'should reduce users balance' do
      shipping = Money.new(1000, 'PLN')
      expect(user).to receive(:subtract).with(Money.new(2200, 'PLN'), :payer)
      dish.subtract shipping, :payer
    end
  end
end
