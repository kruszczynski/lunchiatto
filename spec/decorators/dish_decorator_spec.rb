require 'spec_helper'

describe DishDecorator do
  let(:user) {create(:user)}
  let(:other_user) {create :other_user}
  let(:order) {create :order, user: user}
  let(:dish) {create :dish, user: user, order: order}
  let(:other_dish) {create :dish, user: other_user, order: order}

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

  describe "#editable?" do
    describe "order in progress" do
      it "returns true when user's" do
        expect(@dish.editable?).to be_truthy
      end
      it "returns false when other user's" do
        allow(@dish).to receive(:current_user).and_return(other_user)
        expect(@dish.editable?).to be_falsey
      end
    end
    describe "order ordered" do
      before do
        order.ordered!
      end
      it "returns false when user's" do
        @other_dish = other_dish.decorate
        allow(@other_dish).to receive(:current_user).and_return(other_user)
        expect(@other_dish.editable?).to be_falsey
      end
      it "returns false when other user's" do
        allow(@dish).to receive(:current_user).and_return(other_user)
        expect(@dish.editable?).to be_falsey
      end
      it "returns true when edited by orderer" do
        @other_dish = other_dish.decorate
        allow(@other_dish).to receive(:current_user).and_return(user)
        expect(@other_dish.editable?).to be_truthy
      end
    end
    describe "order delivered" do
      before do
        order.delivered!
      end
      it "returns false when user's" do
        expect(@dish.editable?).to be_falsey
      end
      it "returns false when other user's" do
        allow(@dish).to receive(:current_user).and_return(other_user)
        expect(@dish.editable?).to be_falsey
      end
    end
  end

  describe "#deletable?" do
    describe "order in progress" do
      it "is true for the user" do
        expect(@dish.deletable?).to be_truthy
      end
      it "is false for the other user" do
        allow(@dish).to receive(:current_user).and_return(other_user)
        expect(@dish.deletable?).to be_falsey
      end
    end
    describe "order ordered" do
      before do
        order.ordered!
      end
      it "is false for the user" do
        expect(@dish.deletable?).to be_falsey
      end
      it "is false for the other user" do
        allow(@dish).to receive(:current_user).and_return(other_user)
        expect(@dish.deletable?).to be_falsey
      end
    end
    describe "order delivered" do
      before do
        order.delivered!
      end
      it "is false for the user" do
        expect(@dish.deletable?).to be_falsey
      end
      it "is false for the other user" do
        allow(@dish).to receive(:current_user).and_return(other_user)
        expect(@dish.deletable?).to be_falsey
      end
    end
  end

  describe "#copyable?" do
    describe "order in progress" do
      it "is true for the user" do
        expect(@dish.copyable?).to be_falsey
      end
      it "is false for the other user" do
        allow(@dish).to receive(:current_user).and_return(other_user)
        expect(@dish.copyable?).to be_truthy
      end
    end
    describe "order ordered" do
      before do
        order.ordered!
      end
      it "is false for the user" do
        expect(@dish.copyable?).to be_falsey
      end
      it "is false for the other user" do
        allow(@dish).to receive(:current_user).and_return(other_user)
        expect(@dish.copyable?).to be_falsey
      end
    end
    describe "order delivered" do
      before do
        order.delivered!
      end
      it "is false for the user" do
        expect(@dish.copyable?).to be_falsey
      end
      it "is false for the other user" do
        allow(@dish).to receive(:current_user).and_return(other_user)
        expect(@dish.copyable?).to be_falsey
      end
    end
  end
end