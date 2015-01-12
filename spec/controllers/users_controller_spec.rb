require 'spec_helper'

describe UsersController, type: :controller do
  describe 'GET :edit' do
    before do
      @user = create(:user)
      @other_user = create(:other_user)
    end
    describe 'html' do
      it 'renders edit page' do
        sign_in @user
        get :edit, id: @user.id
        expect(response).to render_template :edit
      end
      it 'redirects not signed in user to root' do
        get :edit, id: @user.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PUT :update' do
    before do
      @user = create(:user)
    end
    describe 'json' do
      it 'returns user object on json' do
        sign_in @user
        put :update, id: @user.id, user: {substract_from_self: true}, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns 401 for unlogged in json' do
        put :update, id: @user.id, user: {substract_from_self: true}, format: :json
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET :index' do
    before do
      @user = create(:user)
      @other_user = create(:other_user)
    end
    describe 'json' do
      it 'rejects when not logged in' do
        get :index, format: :json
        expect(response).to have_http_status(401)
      end
      it 'renders json' do
        sign_in @user
        get :index, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET :show' do
    describe 'json' do
      before do
        @user = create :user
      end
      it 'rejects when not logged in' do
        get :show, id: @user.id, format: :json
        expect(response).to have_http_status(401)
      end
      it 'renders json' do
        sign_in @user
        get :show, id: @user.id, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end
end
