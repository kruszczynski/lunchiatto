require 'spec_helper'

describe TransferSerializer do
  let(:transfer) {build :transfer}
  let(:serializer) {TransferSerializer.new transfer}

  describe '#amount' do
    it 'delegates amount' do
      expect(transfer).to receive(:amount).and_return(11)
      expect(serializer.amount).to eq("11")
    end
  end
  describe '#from' do
    it 'returns name' do
      from = double('from')
      expect(from).to receive(:name).and_return('Tom')
      expect(transfer).to receive(:from).and_return(from)
      expect(serializer.from).to eq("Tom")
    end
  end

  describe '#to' do
    it 'returns name' do
      to = double('to')
      expect(to).to receive(:name).and_return('Rich')
      expect(transfer).to receive(:to).and_return(to)
      expect(serializer.to).to eq("Rich")
    end
  end


  describe '#created_at' do
    it 'formats the date' do
      expect(transfer).to receive(:created_at).and_return(DateTime.new(2013,12,14,12,12))
      expect(serializer.created_at).to eq('Sat, 14 Dec 2013 12:12:00 +0000')
    end
  end
end