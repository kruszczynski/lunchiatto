require 'spec_helper'

describe DishesController, :type => :controller do
  before do
    @user = create(:user)
    @order = build(:order) do |order|
      order.user = @user
      order.save!
    end
  end
  describe 'GET new' do
    describe 'html' do
      it 'renders new page' do
        sign_in @user
        get :new, order_id: @order.id
        expect(response).to render_template :new
      end

      it 'redirects to index when not logged in' do
        get :new, order_id: @order.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST create' do
    describe 'html' do
      it 'creates an order' do
        sign_in @user
        expect {
          post :create,order_id: @order.id, dish: {user_id: @user.id, name: 'Name', price_cents: 14}
        }.to change(Dish, :count)
      end
      it 'redirects to dashboard after' do
        sign_in @user
        post :create,order_id: @order.id, dish: {user_id: @user.id, name: 'Name', price_cents: 14}
        expect(response).to redirect_to dashboard_users_path
      end
      it 'redirects to index when not logged in' do
        post :create,order_id: @order.id, dish: {user_id: @user.id, name: 'Name', price_cents: 14}
        expect(response).to redirect_to root_path
      end
    end
    describe 'json' do
      it 'rejects when not logged in' do
        post :create, order_id: @order.id, dish: {user_id: @user.id, name: 'Name', price_cents: 14}, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in @user
        post :create, order_id: @order.id, dish: {user_id: @user.id, name: 'Name', price_cents: 14}, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns errors' do
        sign_in @user
        post :create, order_id: @order.id, dish: {user_id: @user.id, price_cents: 14}, format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET edit' do
    before do
      @dish = build(:dish) do |dish|
        dish.user = @user
        dish.order = @order
      end
      @dish.save!
    end
    describe 'html' do
      it 'renders edit page' do
        sign_in @user
        get :edit, order_id: @order.id, id: @dish.id
        expect(response).to render_template :edit
      end

      it 'redirects to index when not logged in' do
        get :edit, order_id: @order.id, id: @dish.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST update' do
    before do
      @dish = build(:dish) do |dish|
        dish.user = @user
        dish.order = @order
      end
      @dish.save!
    end
    describe 'html' do
      it 'redirects to dashboard after' do
        sign_in @user
        put :update, order_id: @order.id, id: @dish.id, dish: {user_id: @user.id, name: 'Name', price: 13}
        expect(response).to redirect_to dashboard_users_path
      end
      it 'redirects to index when not logged in' do
        put :update, order_id: @order.id, id: @dish.id, dish: {user_id: @user.id, name: 'Name', price: 13}
        expect(response).to redirect_to root_path
      end
    end
    describe 'json' do
      it 'rejects when not logged in' do
        put :update, order_id: @order.id, id: @dish.id, dish: {user_id: @user.id, name: 'Name', price: 13}, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in @user
        put :update, order_id: @order.id, id: @dish.id, dish: {user_id: @user.id, name: 'Name', price: 13}, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns errors' do
        sign_in @user
        put :update, order_id: @order.id, id: @dish.id, dish: {user_id: @user.id, name: '', price: 13}, format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      @dish = build(:dish) do |dish|
        dish.user = @user
        dish.order = @order
      end
      @dish.save!
    end
    describe 'html' do
      it 'redirects to dashboard after' do
        sign_in @user
        delete :destroy, order_id: @order.id, id: @dish.id
        expect(response).to redirect_to dashboard_users_path
      end
      it 'decrements the dishes count' do
        sign_in @user
        expect {
          delete :destroy, order_id: @order.id, id: @dish.id
        }.to change(Dish, :count).by(-1)
      end
      it 'redirects to index when not logged in' do
        delete :destroy, order_id: @order.id, id: @dish.id
        expect(response).to redirect_to root_path
      end
    end
    describe 'json' do
      it 'rejects when not logged in' do
        delete :destroy, order_id: @order.id, id: @dish.id, format: :json
        expect(response).to have_http_status(401)
      end
      it 'decrements the dishes count' do
        sign_in @user
        expect {
          delete :destroy, order_id: @order.id, id: @dish.id, format: :json
        }.to change(Dish, :count).by(-1)
      end
      it 'is success' do
        sign_in @user
        delete :destroy, order_id: @order.id, id: @dish.id, format: :json
        expect(response).to have_http_status(:success)
        expect(response.body).to eq({status: 'success'}.to_json)
      end
    end
  end

  describe 'GET copy' do
    before do
      @other_user = create(:other_user)
      @dish = build(:dish) do |dish|
        dish.user = @user
        dish.order = @order
      end
      @dish.save
    end
    describe 'html' do
      it 'copies a new dish' do
        sign_in @other_user
        expect {
          get :copy, order_id: @order.id, id: @dish.id
        }.to change(Dish, :count).by(1)
      end
      it 'doesnt copy a dish if a user already has a dish in that order' do
        sign_in @user
        expect {
          get :copy, order_id: @order.id, id: @dish.id
        }.to_not change(Dish, :count)
      end
      it 'redirects to dashboard' do
        sign_in @other_user
        get :copy, order_id: @order.id, id: @dish.id
        expect(response).to redirect_to(dashboard_users_path)
      end
    end
  end
end
