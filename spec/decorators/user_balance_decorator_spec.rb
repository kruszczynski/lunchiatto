require 'spec_helper'

describe UserBalanceDecorator do
  before do
    @user = create(:user)
    @user_balance = create :user_balance, user: @user, payer: @user, balance_cents: 1241
    @decorator = @user_balance.decorate
  end

  it 'should to_s' do
    expect(@decorator.to_s).to eq(@user_balance.balance.to_s)
  end

end