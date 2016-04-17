# frozen_string_literal: true
require 'spec_helper'

describe UserBalanceSerializer do
  let(:user_balance) { double :user_balance }
  let(:serializer) { described_class.new user_balance }

  describe '#balance' do
    it 'delegates balance' do
      expect(user_balance).to receive(:balance).and_return(41)
      expect(serializer.balance).to eq('41')
    end
  end

  describe '#created_at' do
    it 'formats the date' do
      expect(user_balance).to receive(:created_at)
        .and_return(DateTime.new(2013, 12, 12, 12, 12).in_time_zone)
      expect(serializer.created_at)
        .to eq('Thu, 12 Dec 2013 12:12:00.000000000 +0000')
    end
  end
end
