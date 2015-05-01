require "spec_helper"

describe OrderDecorator do
  let!(:user) {create :user}
  let(:order) {create(:order, user: user).decorate}
  let(:old_order) {create(:order, user: user, date: 1.day.ago).decorate}
  let(:other_user) {create :other_user}
  let!(:dish) {create :dish, user: other_user, order: order}

  describe "#current_user_ordered?" do
    it "returns false when users differ" do
      sign_in user
      expect(order.current_user_ordered?).to be_falsey
    end

    it "returns true when users do not differ" do
      sign_in other_user
      expect(order.current_user_ordered?).to be_truthy
    end
  end

  describe "#ordered_by_current_user?" do
    it "returns true when user is the orderer" do
      sign_in user
      expect(order.ordered_by_current_user?).to be_truthy
    end
    it "returns false otherwise" do
      sign_in other_user
      expect(order.ordered_by_current_user?).to be_falsey
    end
  end

  describe "#from_today?" do
    it "returns true when from today" do
      expect(order.from_today?).to be_truthy
    end
    it "returns false when older" do
      expect(old_order.from_today?).to be_falsey
    end
  end
end