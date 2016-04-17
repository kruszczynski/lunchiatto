# frozen_string_literal: true
require 'spec_helper'

describe TransferPolicy do
  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let(:transfer) { create :transfer, from: other_user, to: user }
  subject { described_class.new user, transfer }

  describe '#create?' do
    it 'returns true' do
      expect(subject.create?)
    end
  end

  describe '#update?' do
    it 'returns true when pending and to user' do
      expect(subject.update?).to be_truthy
    end
    it 'returns false when transfer accepted' do
      transfer.mark_as_accepted!
      expect(subject.update?).to be_falsey
    end
    it 'returns false when transfer rejected' do
      transfer.mark_as_rejected!
      expect(subject.update?).to be_falsey
    end
    it 'returns false when pending and to a different user' do
      policy = described_class.new other_user, transfer
      expect(policy.update?).to be_falsey
    end
  end
end
