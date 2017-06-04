# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TransferSerializer do
  let(:from) { build(:user, name: 'Tom') }
  let(:to) { build(:user, name: 'Rich') }
  let(:transfer) do
    build(
      :transfer,
      amount: 11,
      from: from,
      to: to,
      created_at: DateTime.new(2013, 12, 14, 12, 12).in_time_zone,
    )
  end
  subject { described_class.new(transfer) }

  describe '#amount' do
    it { expect(subject.amount).to eq('11.00') }
  end

  describe '#from' do
    it { expect(subject.from).to eq('Tom') }
  end

  describe '#to' do
    it { expect(subject.to).to eq('Rich') }
  end

  describe '#created_at' do
    it { expect(subject.created_at).to eq('Sat, 14 Dec 2013 12:12:00 +0000') }
  end
end
