# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let(:company) { create :company }
  let!(:user) { create :user, company: company }
  let!(:other_user) { create :other_user }
  describe 'PUT :update' do
    describe 'json' do
      it 'returns user object on json' do
        sign_in user
        put :update,
            params: {
              id: user.id,
              user: {subtract_from_self: true},
            },
            format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns 401 for unlogged in json' do
        put :update,
            params: {
              id: user.id,
              user: {subtract_from_self: true},
            },
            format: :json
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
