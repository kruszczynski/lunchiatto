require 'spec_helper'

describe OrderSerializer do
  let(:company) { create :company }
  let(:user) { create :user, company: company }
  let(:order) { create :order, user: user, company: company }
  let(:serializer) { OrderSerializer.new order, scope: user }
  let(:policy) { double('OrderPolicy') }

  describe '#shipping' do
    it 'delegates shipping' do
      expect(order).to receive(:shipping).and_return(11)
      expect(serializer.shipping).to eq('11')
    end
  end

  describe '#total' do
    it 'returns adequate' do
      expect(order).to receive(:shipping).and_return(3)
      expect(order).to receive(:amount).and_return(7)
      expect(serializer.total).to eq('10')
    end
  end

  describe 'with policy' do
    before do
      allow(OrderPolicy).to receive(:new) { policy }
      allow(serializer).to receive(:current_user) { user }
    end

    it '#editable?' do
      expect(policy).to receive(:update?) { true }
      expect(serializer.editable?).to be_truthy
    end

    it '#deletable?' do
      expect(policy).to receive(:destroy?) { true }
      expect(serializer.deletable?).to be_truthy
    end
  end
end
