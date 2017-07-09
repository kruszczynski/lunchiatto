# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::BalancesController, type: :controller do
  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let!(:payment_one) do
    create :payment, user: user, payer: user, balance: 10
  end
  let!(:payment_two) do
    create :payment, user: user, payer: other_user, balance: 40
  end
  let!(:payment_three) do
    create :payment, user: user, payer: other_user, balance: 40
  end
  let!(:payment_four) do
    create :payment, user: user, payer: user, balance: 40
  end
  let!(:payment_five) do
    create :payment, user: other_user, payer: other_user, balance: 40
  end

  describe 'GET :index' do
    it 'is success with non-zero balances' do
      sign_in user
      get :index, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to be(1)
    end

    it 'rejects when not logged in' do
      get :index, format: :json
      expect(response).to have_http_status(401)
    end
  end
end
