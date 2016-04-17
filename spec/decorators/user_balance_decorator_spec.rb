# frozen_string_literal: true
require 'spec_helper'

describe UserBalanceDecorator do
  let(:user) { create(:user) }
  let(:user_balance) do
    create :user_balance, user: user, payer: user, balance_cents: 1241
  end
  let(:decorator) { user_balance.decorate }

  it 'to_ses' do
    expect(decorator.to_s).to eq(user_balance.balance.to_s)
  end
end
