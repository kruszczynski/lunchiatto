require 'spec_helper'

describe UserBalance, :type => :model do
  it {should belong_to(:user)}
  it {should belong_to(:payer)}
  it {should validate_presence_of(:user)}
  it {should validate_presence_of(:payer)}
  it 'should monetize balance' do
    expect(monetize(:balance_cents)).to be_truthy
  end

  describe '.balances_for' do
    before do
      @user = create :user
      @other_user = create :other_user
      @balance_one = create :user_balance, user: @user, payer: @user, balance: 10
      @balance_two = create :user_balance, user: @user, payer: @other_user, balance: 40
      @balance_three = create :user_balance, user: @user, payer: @other_user, balance: 40
      @balance_four = create :user_balance, user: @user, payer: @user, balance: 40
      @balance_five = create :user_balance, user: @other_user, payer: @other_user, balance: 40
    end
    it 'should call adequate methods' do
      expect(UserBalance).to receive(:payers_ids).with(@user).and_return([@user.id, @other_user.id])
      expect(UserBalance.balances_for(@user)).to contain_exactly(@balance_four, @balance_three)
    end
  end

  describe '.payers_ids' do
    before do
      @user = create :user
      @other_user = create :other_user
      @balance_one = create :user_balance, user: @user, payer: @user, balance: 10
      @balance_two = create :user_balance, user: @user, payer: @other_user, balance: 40
      @balance_three = create :user_balance, user: @user, payer: @other_user, balance: 40
      @balance_four = create :user_balance, user: @user, payer: @user, balance: 40
      @balance_five = create :user_balance, user: @other_user, payer: @other_user, balance: 40
    end
    it 'returns adequate ids' do
      expect(UserBalance.payers_ids(@user)).to contain_exactly(@other_user.id, @user.id)
    end
  end

  describe '.debtors_ids' do
    before do
      @user = create :user
      @other_user = create :other_user
      @balance_one = create :user_balance, user: @user, payer: @user, balance: 10
      @balance_three = create :user_balance, payer: @user, user: @other_user, balance: 40
    end
    it 'returns adequate ids' do
      expect(UserBalance.debtors_ids(@user)).to contain_exactly(@other_user.id, @user.id)
    end
  end

  describe '.debts_to' do
    before do
      @user = create :user
      @other_user = create :other_user
      @balance_one = create :user_balance, user: @user, payer: @user, balance: 10
      @balance_two = create :user_balance, user: @user, payer: @other_user, balance: 40
      @balance_three = create :user_balance, user: @user, payer: @other_user, balance: 40
      @balance_four = create :user_balance, user: @other_user, payer: @user, balance: 40
      @balance_five = create :user_balance, user: @other_user, payer: @other_user, balance: 40
    end
    it 'should call adequate methods' do
      expect(UserBalance).to receive(:debtors_ids).with(@user).and_return([@user.id, @other_user.id])
      expect(UserBalance.debts_to(@user)).to contain_exactly(@balance_four, @balance_one)
    end
  end
end
