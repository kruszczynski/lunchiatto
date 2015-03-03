require 'spec_helper'

describe OrderSerializer do
  let(:order) {build :order}
  let(:serializer) {OrderSerializer.new order}

  describe '#shipping' do
    it 'delegates shipping' do
      expect(order).to receive(:shipping).and_return(11)
      expect(serializer.shipping).to eq("11")
    end
  end

  describe '#total' do
    it 'returns adequate' do
      expect(order).to receive(:shipping).and_return(3)
      expect(order).to receive(:amount).and_return(7)
      expect(serializer.total).to eq("10")
    end
  end
end