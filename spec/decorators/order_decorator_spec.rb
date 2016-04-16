# frozen_string_literal: true
require 'spec_helper'

describe OrderDecorator, type: :decorator do
  let(:company) { create :company }
  let!(:user) { create :user, company: company }
  let(:order) { create(:order, user: user, company: company).decorate }
  let(:current_user) { user }
  let(:old_order) do
    create(:order, user: user, date: 1.day.ago, company: company).decorate
  end
  let(:other_user) { create :other_user, company: company }
  let!(:dish) { create :dish, user: other_user, order: order }

  before do
    allow(order).to receive(:current_user) { current_user }
  end

  describe '#current_user_ordered?' do
    it 'returns false when users differ' do
      expect(order.current_user_ordered?).to be_falsey
    end

    context 'with other user' do
      let(:current_user) { other_user }
      it 'returns true when users do not differ' do
        expect(order.current_user_ordered?).to be_truthy
      end
    end
  end

  describe '#ordered_by_current_user?' do
    it 'returns true when user is the orderer' do
      expect(order.ordered_by_current_user?).to be_truthy
    end

    context 'with other user' do
      let(:current_user) { other_user }
      it 'returns false otherwise' do
        expect(order.ordered_by_current_user?).to be_falsey
      end
    end
  end

  describe '#from_today?' do
    it 'returns true when from today' do
      expect(order.from_today?).to be_truthy
    end
    it 'returns false when older' do
      expect(old_order.from_today?).to be_falsey
    end
  end
end
