require 'spec_helper'

describe OrderDecorator do
  let!(:user) {create :user}
  let(:order) {create(:order, user: user).decorate}
  let(:old_order) {create(:order, user: user, date: Date.yesterday).decorate}
  let(:other_user) {create :other_user}
  let!(:dish) {create :dish, user: other_user, order: order}

  describe '#current_user_ordered?' do
    it 'returns false when users differ' do
      sign_in user
      expect(order.current_user_ordered?).to be_falsey
    end

    it 'returns true when users do not differ' do
      sign_in other_user
      expect(order.current_user_ordered?).to be_truthy
    end
  end

  describe '#ordered_by_current_user?' do
    it 'returns true when user is the orderer' do
      sign_in user
      expect(order.ordered_by_current_user?).to be_truthy
    end
    it 'returns false otherwise' do
      sign_in other_user
      expect(order.ordered_by_current_user?).to be_falsey
    end
  end

  describe "#editable?" do
    it "returns true when in_progress" do
      sign_in user
      expect(order.editable?).to be_truthy
    end
    describe "ordered" do
      before do
        order.ordered!
      end
      it "returns true when user is the payer" do
        sign_in user
        expect(order.editable?).to be_truthy
      end
      it "returns false otherwise" do
        sign_in other_user
        expect(order.editable?).to be_falsey
      end
    end
    it "returns false when delivered" do
      order.delivered!
      sign_in user
      expect(order.editable?).to be_falsey
    end
  end

  describe "#can_change_status?" do
    describe "in_progress" do
      it "returns true for payer" do
        sign_in user
        expect(order.can_change_status?).to be_truthy
      end
      it "returns false for other user" do
        sign_in other_user
        expect(order.can_change_status?).to be_falsey
      end
    end
    describe "ordered" do
      before do
        order.ordered!
      end
      it "returns true for payer" do
        sign_in user
        expect(order.can_change_status?).to be_truthy
      end
      it "returns false for other user" do
        sign_in other_user
        expect(order.can_change_status?).to be_falsey
      end
    end
    describe "delivered" do
      before do
        order.delivered!
      end
      it "returns false for payer" do
        sign_in user
        expect(order.can_change_status?).to be_falsey
      end
      it "returns false for other user" do
        sign_in other_user
        expect(order.can_change_status?).to be_falsey
      end
    end
  end

  describe "#deletable?" do
    it "returns false when ordered" do
      order.ordered!
      sign_in user
      expect(order.deletable?).to be_falsey
    end
    it "returns false when delivered" do
      order.delivered!
      sign_in user
      expect(order.deletable?).to be_falsey
    end
    describe "when in progress" do
      it "returns true for payer" do
        sign_in user
        expect(order.deletable?).to be_truthy
      end
      it "returns false for other user" do
        sign_in other_user
        expect(order.deletable?).to be_falsey
      end
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