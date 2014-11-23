require 'spec_helper'

describe OrdersController, :type => :controller do
  before do
    @user = create(:user)
  end
  describe 'GET new' do
    describe 'html' do
      it 'renders new page' do
        sign_in @user
        get :new
        expect(response).to render_template :new
      end

      it 'redirects to index when not logged in' do
        get :new
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST create' do
    it 'creates an order' do
      sign_in @user
      expect {
        post :create, order: {user_id: @user.id, from: 'A restaurant'}
      }.to change(Order, :count)
    end
    describe 'html' do
      it 'redirects to dashboard after' do
        sign_in @user
        post :create, order: {user_id: @user.id, from: 'A restaurant'}
        expect(response).to redirect_to dashboard_users_path
      end
      it 'redirects to index when not logged in' do
        post :create
        expect(response).to redirect_to root_path
      end
    end
    describe 'json' do
      it 'rejects when not logged in' do
        post :create, order: {user_id: @user.id, from: 'A restaurant'}, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in @user
        post :create, order: {user_id: @user.id, from: 'A restaurant'}, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns errors' do
        sign_in @user
        post :create, order: {from: 'A restaurant'}, format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET edit' do
    before do
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save
    end
    describe 'html' do
      it 'renders edit page' do
        sign_in @user
        get :edit, id: @order.id
        expect(response).to render_template :edit
      end
      it 'redirects to index when not logged in' do
        get :edit, id: @order.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PUT update' do
    before do
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save
    end
    describe 'html' do
      it 'redirects to dashboard after' do
        sign_in @user
        put :update, id: @order.id, order: {user_id: @user.id}
        expect(response).to redirect_to dashboard_users_path
      end

      it 'redirects to index when not logged in' do
        put :update, id: @order.id
        expect(response).to redirect_to root_path
      end
    end
    describe 'json' do
      it 'rejects when not logged in' do
        put :update, id: @order.id, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in @user
        other_user = create :other_user
        put :update, id: @order.id, order: {user_id: other_user.id}, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns errors' do
        sign_in @user
        put :update, id: @order.id, order: {from: ''}, format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET show' do
    before do
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save
    end
    describe 'html' do
      it 'renders show template' do
        sign_in @user
        get :show, id: @order.id
        expect(response).to render_template :show
      end
      it 'redirects to index when not logged in' do
        put :update, id: @order.id
        expect(response).to redirect_to root_path
      end
    end
    describe 'json' do
      it 'rejects when not logged in' do
        get :show, id: @order.id, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in @user
        get :show, id: @order.id, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PUT change_status' do
    before do
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save
    end
    describe 'html' do
      it 'redirects to dashboard after' do
        sign_in @user
        put :change_status, id: @order.id
        expect(response).to redirect_to dashboard_users_path
      end
      it 'redirects to index when not logged in' do
        put :update, id: @order.id
        expect(response).to redirect_to root_path
      end
    end
    describe 'json' do
      it 'rejects when not logged in' do
        put :change_status, id: @order.id, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in @user
        put :change_status, id: @order.id, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET shipping' do
    before do
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save
    end
    describe 'html' do
      it 'is success' do
        sign_in @user
        get :shipping, id: @order.id
        expect(response).to render_template :shipping
      end
      it 'redirects to index when not logged in' do
        get :shipping, id: @order.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET :index' do
    describe 'html' do
      it 'is success' do
        sign_in @user
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end
    describe 'json' do
      it 'rejects when not logged in' do
        get :index, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns json' do
        sign_in @user
        get :index, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET :latest' do
    before do
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save!
    end
    describe 'json' do
      it 'rejects when not logged in' do
        get :latest, format: :json
        expect(response).to have_http_status(401)
      end
      it 'renders json' do
        sign_in @user
        get :latest, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end
end