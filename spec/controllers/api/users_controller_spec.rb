# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let(:company) { create :company }
  let!(:user) { create :user, company: company }
  let!(:other_user) { create :other_user }
  describe 'PUT :update' do
    describe 'json' do
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
      it 'returns only current company users' do
        users_index
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.count).to eq(1)
      end
    end
    def users_index
      sign_in user
      get :index, format: :json
    end
  end

  describe 'GET :show' do
    describe 'json' do
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
  end
end
