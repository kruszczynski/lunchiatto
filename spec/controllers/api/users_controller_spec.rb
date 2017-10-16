# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let!(:user) { create(:user, account_number: '23421234') }
  let!(:other_user) { create :other_user }
  describe 'PUT :update' do
    let(:update_params) { {id: user.id, account_number: '13'} }
    let(:call) { put :update, params: update_params, format: :json }

    context 'when success' do
      before { sign_in user }

      it 'returns user object on json' do
        call
        expect(response).to have_http_status(:success)
      end

      it 'changes account number' do
        call
        expect(user.reload.account_number).to eq('13')
      end
    end

    it 'returns 401 for unlogged in json' do
      call
      expect(response).to have_http_status(401)
    end
  end

  describe 'GET :index' do
    describe 'json' do
      it 'rejects when not logged in' do
        get :index, format: :json
        expect(response).to have_http_status(401)
      end
      it 'renders json' do
        users_index
        expect(response).to have_http_status(:success)
      end
      it 'returns all users' do
        users_index
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.count).to eq(2)
      end
    end
    def users_index
      sign_in user
      get :index, format: :json
    end
  end

  describe 'GET :show' do
    it 'rejects when not logged in' do
      get :show, params: {id: user.id}, format: :json
      expect(response).to have_http_status(401)
    end

    it 'renders json' do
      sign_in user
      get :show, params: {id: user.id}, format: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET :me' do
    it 'rejects when not logged in' do
      get :me, format: :json
      expect(response).to have_http_status(401)
    end

    it 'returns a success' do
      sign_in user
      get :me, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns current user' do
      sign_in user
      get :me, format: :json
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(
        'account_balance' => '0.00',
        'account_number' => '23421234',
        'admin' => false,
        'id' => user.id,
        'name' => 'Bartek Szef',
        'pending_transfers_count' => 0,
        'total_balance' => '0.00',
      )
    end
  end
end
