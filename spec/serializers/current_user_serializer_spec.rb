require 'spec_helper'

describe CurrentUserSerializer do
  before do
    @user = double(:user)
    @serializer = CurrentUserSerializer.new @user
  end

  it '#total_balance' do
    expect(@user).to receive(:total_balance).and_return(12)
    expect(@serializer.total_balance).to eq('12')
  end
end