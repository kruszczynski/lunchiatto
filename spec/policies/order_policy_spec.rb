# frozen_string_literal: true
require 'spec_helper'

describe OrderPolicy do
  let(:company) { create :company }
  let(:user) { create :user, company: company }
  let(:other_user) { create :other_user, company: company }
  let(:order) { create :order, user: user, company: company }
  subject { OrderPolicy.new user, order }

  describe '#index?' do
    it 'returns true' do
      expect(subject.index?).to be_truthy
    end
  end

  describe '#update?' do
    describe 'in progress' do
      it 'returns true when in_progress' do
        expect(subject.update?).to be_truthy
      end
      it 'returns true for other user' do
        policy = OrderPolicy.new other_user, order
        expect(policy.update?).to be_truthy
      end
    end
    describe 'ordered' do
      before do
        order.ordered!
      end
      it 'returns true when user is the payer' do
        expect(subject.update?).to be_truthy
      end
      it 'returns false otherwise' do
        policy = OrderPolicy.new other_user, order
        expect(policy.update?).to be_falsey
      end
    end
    it 'returns false when delivered' do
      order.delivered!
      expect(subject.update?).to be_falsey
    end
  end

  describe '#change_status?' do
    describe 'in_progress' do
      it 'returns true for payer' do
        expect(subject.change_status?).to be_truthy
      end
      it 'returns false for other user' do
        policy = OrderPolicy.new other_user, order
        expect(policy.change_status?).to be_falsey
      end
    end
    describe 'ordered' do
      before do
        order.ordered!
      end
      it 'returns true for payer' do
        expect(subject.change_status?).to be_truthy
      end
      it 'returns false for other user' do
        policy = OrderPolicy.new other_user, order
        expect(policy.change_status?).to be_falsey
      end
    end
    describe 'delivered' do
      before do
        order.delivered!
      end
      it 'returns false for payer' do
        expect(subject.change_status?).to be_falsey
      end
      it 'returns false for other user' do
        policy = OrderPolicy.new other_user, order
        expect(policy.change_status?).to be_falsey
      end
    end
  end

  describe '#destroy?' do
    it 'returns false when ordered' do
      order.ordered!
      expect(subject.destroy?).to be_falsey
    end
    it 'returns false when delivered' do
      order.delivered!
      expect(subject.destroy?).to be_falsey
    end
    describe 'when in progress' do
      it 'returns true for payer' do
        expect(subject.destroy?).to be_truthy
      end
      it 'returns false for other user' do
        policy = OrderPolicy.new other_user, order
        expect(policy.destroy?).to be_falsey
      end
    end
  end
end
