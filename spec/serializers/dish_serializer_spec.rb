require 'spec_helper'

describe DishSerializer do
  before do
    @dish = create :dish
    @serializer = DishSerializer.new @dish
  end

  describe '#price' do
    it 'delegates price' do
      expect(@dish).to receive(:price).and_return(15)
      expect(@serializer.price).to eq("15")
    end
  end
end