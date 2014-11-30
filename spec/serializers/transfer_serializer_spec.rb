require 'spec_helper'

describe TransferSerializer do
  before do
    @transfer = build :transfer
    @serializer = TransferSerializer.new @transfer
  end

  describe '#amount' do
    it 'delegates amount' do
      expect(@transfer).to receive(:amount).and_return(11)
      expect(@serializer.amount).to eq("11")
    end
  end
end