# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Balance do
  context 'given two users' do
    let(:user_1) { create(:user) }
    let(:user_2) { create(:other_user)}
    let(:user_3) { create(:yet_another_user) }

    shared_context 'pays_for' do |payer, user, amt|
      before do
        create(
          :payment, user: eval(user), payer: eval(payer), balance_cents: amt)
      end
    end

    it '#balance_for raises if users are equal' do
      expect do
        described_class.new(user_1).balance_for(user_1)
      end.to raise_error(ArgumentError)
    end

    context 'it is 0 for user_1' do
      subject { described_class.new(user_1) }

      it { expect(subject.total).to eq(0) }
    end

    context 'it is 1 for user_2' do
      subject { described_class.new(user_2) }

      it { expect(subject.total).to eq(0) }
    end

    context 'given one transaction' do
      2.times { include_context 'pays_for', 'user_2', 'user_1', 100 }
      subject { described_class.new(user_1) }

      it { expect(subject.total).to eq(-200) }
      it { expect(subject.balance_for(user_2)).to eq(-200) }

      context 'for other user' do
        subject { described_class.new(user_2) }

        it { expect(subject.total).to eq(200) }
        it { expect(subject.balance_for(user_1)).to eq(200) }
      end
    end

    context 'given two transactions with distinct payers' do
      2.times { include_context 'pays_for', 'user_2', 'user_1', 100 }
      include_context 'pays_for', 'user_1', 'user_2', 150

      subject { described_class.new(user_1) }

      it { expect(subject.total).to eq(-50) }
      it { expect(subject.balance_for(user_2)).to eq(-50) }

      context 'for other user' do
        subject { described_class.new(user_2) }

        it { expect(subject.total).to eq(50) }
        it { expect(subject.balance_for(user_1)).to eq(50) }
      end
    end

    context 'given five transactions' do
      2.times { include_context 'pays_for', 'user_2', 'user_1', 100 }
      include_context 'pays_for', 'user_1', 'user_2', 150
      include_context 'pays_for', 'user_3', 'user_1', 200
      include_context 'pays_for', 'user_2', 'user_3', 75

      context 'for user_1' do
        subject { described_class.new(user_1) }

        it { expect(subject.total).to eq(-250) }
        it { expect(subject.balance_for(user_2)).to eq(-50) }
        it { expect(subject.balance_for(user_3)).to eq(-200) }
      end

      context 'for user_2' do
        subject { described_class.new(user_2) }

        it { expect(subject.total).to eq(125) }
        it { expect(subject.balance_for(user_1)).to eq(50) }
        it { expect(subject.balance_for(user_3)).to eq(75) }
      end

      context 'for user_3' do
        subject { described_class.new(user_3) }

        it { expect(subject.total).to eq(125) }
        it { expect(subject.balance_for(user_1)).to eq(200) }
        it { expect(subject.balance_for(user_2)).to eq(-75) }
      end
    end
  end
end
