require 'spec_helper'

describe DishDecorator do
  let(:company) { create(:company) }
  let(:user) { create :user, company: company }
  let(:other_user) { create :other_user, company: company }
  let(:order) { create :order, user: user, company: company }
  let(:old_order) { create :order, user: user, date: 1.day.ago, company: company }
  let(:dish) { create(:dish, user: user, order: order).decorate }

  before do
    allow(dish).to receive(:current_user).and_return(user)
  end

  describe '#belongs_to_current_user?' do
    it 'returns true when user matches' do
      expect(dish.belongs_to_current_user?).to be_truthy
    end

    it 'returns false when users differ' do
      allow(dish).to receive(:current_user).and_return(other_user)
      expect(dish.belongs_to_current_user?).to be_falsey
    end
  end

  describe '#order_by_current_user?' do
    it 'returns true when is is' do
      expect(dish.order_by_current_user?).to be_truthy
    end
    it 'returns false otherwise' do
      order.user = other_user
      order.save!
      expect(dish.order_by_current_user?).to be_falsey
    end
  end

  describe "#from_today" do
    it "return true" do
      expect(dish.from_today?).to be_truthy
    end
    it "returns false" do
      dish.order = old_order
      expect(dish.from_today?).to be_falsey
    end
  end
end
