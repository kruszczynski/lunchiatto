require 'spec_helper'

describe UserSerializer do
  let(:user) {double(:user)}
  let(:serializer) {UserSerializer.new user}

  it '#total_balance' do
    expect(user).to receive(:total_balance) { 12 }
    expect(serializer.total_balance).to eq('12')
  end

  it '#account_balance' do
    expect(serializer).to receive(:current_user) {:current_user}
    expect(user).to receive(:debt_of).with(:current_user) { 12 }
    expect(serializer.account_balance).to eq('12')
  end
end