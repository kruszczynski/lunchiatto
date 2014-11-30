require 'spec_helper'

describe UserBalanceSerializer do
  before do
    @user_balance = double :user_balance
    @serializer = UserBalanceSerializer.new @user_balance
  end

  describe '#balance' do
    it 'delegates balance' do
      expect(@user_balance).to receive(:balance).and_return(41)
      expect(@serializer.balance).to eq('41')
    end
  end
end