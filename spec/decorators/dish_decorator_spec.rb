require 'spec_helper'

describe DishDecorator do
  before do
    @user = create(:user)
    @order = build(:order) do |order|
      order.user = @user
    end
    @order.save
    @dish = build(:dish) do |dish|
      dish.user = @user
      dish.order = @order
    end
    @dish.save!
    @dish = @dish.decorate
    allow(@dish).to receive(:current_user).and_return(@user)
    @other_user = create :other_user
  end

  describe '#belongs_to_current_user?' do
    it 'returns false when users differ' do
      expect(@dish.belongs_to_current_user?).to be_truthy
    end

    it 'returns true when users do not differ' do
      allow(@dish).to receive(:current_user).and_return(@other_user)
      expect(@dish.belongs_to_current_user?).to be_falsey
    end
  end

  describe '#order_by_current_user?' do
    it 'returns true when is is' do
      expect(@dish.order_by_current_user?).to be_truthy
    end
    it 'returns false otherwise' do
      @order.user = @other_user
      @order.save!
      expect(@dish.order_by_current_user?).to be_falsey
    end
  end
end