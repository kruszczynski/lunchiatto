# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OrderSerializer do
  let(:user) { create(:user) }
  let(:shipping) { 0 }
  let(:order) { create(:order, user: user, shipping: shipping) }
  let(:current_user) { user }
  let(:policy) { instance_double('OrderPolicy', update?: true, destroy?: true) }
  subject do
    described_class.new(order, scope: current_user, scope_name: :current_user)
  end

  describe '#shipping' do
    let(:shipping) { 11 }
    it { expect(subject.shipping).to eq('11.00') }
  end # describe '#shipping'

  describe '#total' do
    let(:shipping) { 3 }
    let!(:dish) { create(:dish, order: order, price: 7, user: user) }
    it 'returns adequate' do
      expect(subject.total).to eq('10.00')
    end
  end # describe '#total'

  describe 'with policy' do
    before do
      allow(OrderPolicy).to receive(:new) { policy }
    end

    it '#editable' do
      expect(subject.editable).to be_truthy
    end # it '#editable'

    it '#deletable' do
      expect(subject.deletable).to be_truthy
    end # it '#deletable'
  end # describe 'with policy'

  describe '#current_user_ordered?' do
    it 'returns false when users differ' do
      expect(subject.current_user_ordered).to be_falsey
    end

    context 'with other user' do
      let!(:dish) { create(:dish, order: order, user: user) }

      it 'returns true when users do not differ' do
        expect(subject.current_user_ordered).to be_truthy
      end
    end # context 'with other user'
  end # describe '#current_user_ordered?'

  describe '#ordered_by_current_user?' do
    it 'returns true when user is the orderer' do
      expect(subject.ordered_by_current_user).to be_truthy
    end

    context 'with other user' do
      let(:current_user) { create(:other_user) }
      it 'returns false otherwise' do
        expect(subject.ordered_by_current_user).to be_falsey
      end
    end # context 'with other user'
  end # describe '#ordered_by_current_user?'
end # RSpec.describe OrderSerializer
