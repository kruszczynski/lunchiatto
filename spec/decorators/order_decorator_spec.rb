require 'spec_helper'

describe OrderDecorator do
  before do
    @user = create(:user)
    @order = build(:order) do |order|
      order.user = @user
    end
    @order.save!
    @order = @order.decorate
  end

  describe '#current_user_ordered?' do
    before do
      @other_user = create(:other_user)
      @dish = build(:dish) do |dish|
        dish.user = @other_user
        dish.order = @order
      end
      @dish.save!
    end

    it 'returns false when users differ' do
      sign_in @user
      expect(@order.current_user_ordered?).to be_falsey
    end

    it 'returns true when users do not differ' do
      sign_in @other_user
      expect(@order.current_user_ordered?).to be_truthy
    end
  end

  describe '#ordered_by_current_user?' do
    it 'returns true when user is the orderer' do
      sign_in @user
      expect(@order.ordered_by_current_user?).to be_truthy
    end
    it 'returns false otherwise' do
      other_user = create :other_user
      sign_in other_user
      expect(@order.ordered_by_current_user?).to be_falsey
    end
  end
end