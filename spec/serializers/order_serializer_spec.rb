require 'spec_helper'

describe OrderSerializer do
  before do
    @order = build :order
    @serializer = OrderSerializer.new @order
  end

  describe '#shipping' do
    it 'delegates shipping' do
      expect(@order).to receive(:shipping).and_return(11)
      expect(@serializer.shipping).to eq("11")
    end
  end
end