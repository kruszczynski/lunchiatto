# frozen_string_literal: true
require 'spec_helper'

describe ApplicationPolicy do
  let(:company) { create :company }
  let(:user) { create :user, company: company }
  let(:other_user) { create :other_user, company: company }
  let(:record) { create :order, user: user, company: company }
  subject { ApplicationPolicy.new(user, record) }

  describe '#initialize' do
    it 'assigns user' do
      expect(subject.user).to eq(user)
    end
    it 'assigns record' do
      expect(subject.record).to eq(record)
    end
  end

  describe '#record_belongs_to_user?' do
    it 'returns true' do
      expect(subject.record_belongs_to_user?).to be_truthy
    end
    it 'returns false' do
      record.user = other_user
      expect(subject.record_belongs_to_user?).to be_falsey
    end
  end
end
