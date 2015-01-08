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
    describe 'html' do
      it 'succeeds' do
        sign_in @user
        put :update, id: @user.id, user: {substract_from_self: true}
        expect(response).to redirect_to dashboard_users_path
      end
      it 'redirects not signed in user to root' do
        put :update, id: @user.id, user: {substract_from_self: true}
        expect(response).to redirect_to root_path
      end
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

  describe 'GET :my_balances' do
    before do
      @user = create(:user)
    end
    describe 'html' do
      it 'succeeds' do
        sign_in @user
        get :my_balances, id: @user.id
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:my_balances)
      end
      it 'redirects a different user' do
        other_user = create :other_user
        sign_in other_user
        get :my_balances, id: @user.id
        expect(response).to redirect_to dashboard_users_path
      end
    end
  end

  describe 'GET :account_numbers' do
    before do
      @user = create(:user)
    end
    describe 'html' do
      it 'renders template' do
        sign_in @user
        get :account_numbers
        expect(response).to render_template :account_numbers
      end
      it 'redirects to index when not logged in' do
        get :account_numbers
        expect(response).to redirect_to root_path
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
