# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DishSerializer do
  let(:dish) { instance_double('Dish') }
  let(:policy) { instance_double('DishPolicy') }
  let(:user) { instance_double('User') }
  let(:serializer) { described_class.new dish }

  describe '#price' do
    it 'delegates price' do
      expect(dish).to receive(:price).and_return(15)
      expect(serializer.price).to eq('15')
    end
  end

  describe '#user_name' do
    it 'delegates to user' do
      expect(dish).to receive(:user) { user }
      expect(user).to receive(:name) { 'Total Beaver' }
      expect(serializer.user_name).to eq('Total Beaver')
    end
  end

  context 'with policy' do
    before do
      allow(DishPolicy).to receive(:new) { policy }
      allow(serializer).to receive(:current_user) { user }
    end

    it 'is #editable?' do
      expect(policy).to receive(:update?) { true }
      expect(serializer.editable?).to be_truthy
    end

    it 'is #deletable?' do
      expect(policy).to receive(:destroy?) { true }
      expect(serializer.deletable?).to be_truthy
    end

    it 'is #copyable?' do
      expect(policy).to receive(:copy?) { true }
      expect(serializer.copyable?).to be_truthy
    end
  end
end
