require 'spec_helper'

describe UserSerializer do
  let(:user) {double(:user)}
  let(:serializer) {UserSerializer.new user}

  it '#total_balance' do
    expect(user).to receive(:total_balance).and_return(12)
    expect(serializer.total_balance).to eq('12')
  end
end