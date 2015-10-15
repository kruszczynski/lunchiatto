require 'spec_helper'

describe Api::UsersController, type: :controller do
  let(:company) { create :company }
  let!(:user) { create :user, company: company }
  let!(:other_user) { create :other_user }
  describe 'PUT :update' do
    describe 'json' do
      it 'returns user object on json' do
        sign_in user
        put :update, id: user.id,
                     user: {subtract_from_self: true},
                     format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns 401 for unlogged in json' do
        put :update, id: user.id,
                     user: {subtract_from_self: true},
                     format: :json
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET :index' do
    describe 'json' do
      it 'rejects when not logged in' do
        get_index(should_login: false)
        expect(response).to have_http_status(401)
      end
      it 'renders json' do
        get_index
        expect(response).to have_http_status(:success)
      end
      it 'returns only current company users' do
        get_index
        parsed_response = JSON.parse(response.body)
        expect(parsed_response.count).to eq(1)
      end
    end
    def get_index(should_login: true)
      sign_in user if should_login
      get :index, format: :json
    end
  end

  describe 'GET :show' do
    describe 'json' do
      it 'rejects when not logged in' do
        get :show, id: user.id, format: :json
        expect(response).to have_http_status(401)
      end
      it 'renders json' do
        sign_in user
        get :show, id: user.id, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end
end
