require 'spec_helper'

describe DishSerializer do
  let(:dish) {double(:dish)}
  let(:serializer) {DishSerializer.new dish}

  describe '#price' do
    it 'delegates price' do
      expect(dish).to receive(:price).and_return(15)
      expect(serializer.price).to eq("15")
    end
  end
end