require "spec_helper"

describe Transfer, type: :model do
  before do
    @user = create :user
    @other_user = create :other_user
    @transfer = create :transfer, from: @user, to: @other_user
  end
  it {should belong_to(:from)}
  it {should belong_to(:to)}
  it {should validate_presence_of(:to)}
  it {should validate_presence_of(:from)}

  describe "#mark_as_accepted!" do
    it "should create new balance and change status" do
      expect(@transfer).to receive(:accepted!)
      user_balances = double("UserBalances")
      expect(@user).to receive(:user_balances).and_return(user_balances)
      expect(@user).to receive(:payer_balance).and_return(Money.new(500, "PLN"))
      expect(user_balances).to receive(:create).with(balance: Money.new(2000, "PLN"), payer: @other_user)
      @transfer.mark_as_accepted!
    end
  end

  describe "scope newest_first" do
    it "should order appropriately" do
      expect(Transfer).to receive(:order).with("created_at desc").and_return(:sorted_and_created_at)
      expect(Transfer.newest_first).to eq(:sorted_and_created_at)
    end
  end

  describe "scope from_user" do
    it "filters" do
      expect(Transfer).to receive(:where).with(from_id: 7).and_return(:from_filtered)
      expect(Transfer.from_user(7)).to eq(:from_filtered)
    end
  end

  describe "scope to_user" do
    it "filters" do
      expect(Transfer).to receive(:where).with(to_id: 17).and_return(:to_filtered)
      expect(Transfer.to_user(17)).to eq(:to_filtered)
    end
  end
end