require 'spec_helper'

describe UsersController, type: :controller do
  describe 'GET :dashboard' do
    describe 'html' do
      it 'shows dasboard to signed in user' do
        @user = create(:user)
        @order = build(:order) do |order|
          order.user = @user
        end
        @order.save!
        sign_in @user
        get :dashboard, format: :html
        expect(response).to render_template :dashboard
      end
      it 'redirects not signed in user to root' do
        get :dashboard
        expect(response).to redirect_to root_path
      end
    end

    describe 'json' do
      it 'returns dashboard data' do
        @user = create(:user)
        @order = build(:order) do |order|
          order.user = @user
        end
        @order.save!
        sign_in @user
        get :dashboard, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns 401 for unsigned in' do
        get :dashboard, format: :josn
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET :edit' do
    before do
      @user = create(:user)
      @other_user = create(:other_user)
    end
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

  describe 'GET :account_numbers' do
    before do
      @user = create(:user)
    end
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

  describe 'GET :index' do
    before do
      @user = create(:user)
      @other_user = create(:other_user)
    end
    it 'redirects to index when not logged in' do
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
