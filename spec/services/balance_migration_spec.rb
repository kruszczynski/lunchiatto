# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BalanceMigration do
  let(:bartek) { create(:user) }
  let(:miko) { create(:other_user) }
  let(:jan) { create(:yet_another_user) }

  # rubocop:disable Lint/Eval
  shared_context 'pays_for' do |payer, user, amt|
    before do
      eval(user).subtract(Money.new(amt, 'PLN'), eval(payer))
    end
  end

  shared_context 'repays' do |user, to_payer, amt|
    before do
      attrs = {
        from: eval(user),
        to: eval(to_payer),
        amount: Money.new(amt, 'PLN'),
      }
      Transfer.create(attrs).tap(&:mark_as_accepted!)
    end
  end

  shared_examples_for 'old_total_balance' do |total|
    it "has total balance of #{total}" do
      expect(subject.total_balance).to eq(Money.new(total, 'PLN'))
    end
  end

  shared_examples_for 'new_total_balance' do |num_records, total|
    it "has #{num_records} Payments" do
      count = Payment.where(user: subject).count +
              Payment.where(payer: subject).count
      expect(count).to eq(num_records)
    end

    it "has total new balance of #{total}" do
      expect(Balance.new(subject).total).to eq(Money.new(total, 'PLN'))
    end
  end

  shared_examples_for 'old_balance_for' do |user, amt|
    it "has #{amt} old balance for #{user}" do
      expect(subject.payer_balance(eval(user))).to eq(Money.new(amt, 'PLN'))
    end
  end

  shared_examples_for 'new_balance_for' do |user, amt|
    it "has #{amt} new balance for #{user}" do
      balance_for = Balance.new(subject).balance_for(eval(user))
      expect(balance_for).to eq(Money.new(amt, 'PLN'))
    end
  end
  # rubocop:enable Lint/Eval

  context 'with some transactions' do
    3.times { include_context 'pays_for', 'bartek', 'miko', 100 }
    include_context 'pays_for', 'miko', 'bartek', 250
    include_context 'pays_for', 'jan', 'miko', 125
    include_context 'repays', 'bartek', 'miko', 270
    include_context 'pays_for', 'miko', 'jan', 90
    include_context 'repays', 'bartek', 'jan', 200
    include_context 'pays_for', 'jan', 'bartek', 150

    context 'after migration' do
      before { described_class.perform }

      context 'bartek' do
        subject { bartek }

        it_behaves_like 'old_total_balance', 70
        it_behaves_like 'old_balance_for', 'miko', 20
        it_behaves_like 'old_balance_for', 'jan', 50
        it_behaves_like 'new_total_balance', 7, 370
        it_behaves_like 'new_balance_for', 'miko', 320
        it_behaves_like 'new_balance_for', 'jan', 50
      end

      context 'miko' do
        subject { miko }

        it_behaves_like 'old_total_balance', -425
        it_behaves_like 'old_balance_for', 'bartek', -300
        it_behaves_like 'old_balance_for', 'jan', -125
        it_behaves_like 'new_total_balance', 7, -355
        it_behaves_like 'new_balance_for', 'bartek', -320
        it_behaves_like 'new_balance_for', 'jan', -35
      end

      context 'jan' do
        subject { jan }

        it_behaves_like 'old_total_balance', -90
        it_behaves_like 'old_balance_for', 'bartek', 0
        it_behaves_like 'old_balance_for', 'miko', -90
        it_behaves_like 'new_total_balance', 4, -15
        it_behaves_like 'new_balance_for', 'bartek', -50
        it_behaves_like 'new_balance_for', 'miko', 35
      end
    end
  end
end
