require 'spec_helper'

describe DishDecorator do
  let(:user) {create(:user)}
  let(:order) {create :order, user: user}
  let(:dish) {create :dish, user: user, order: order}
  let(:other_user) {create :other_user}
  
  before do
    @dish = dish.decorate
    allow(@dish).to receive(:current_user).and_return(user)
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
      order.user = other_user
      order.save!
      expect(@dish.order_by_current_user?).to be_falsey
    end
  end
end