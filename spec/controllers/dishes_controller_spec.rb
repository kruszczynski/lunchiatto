require 'spec_helper'

describe DishesController, :type => :controller do
  before do
    @user = create(:user)
    @order = build(:order) do |order|
      order.user = @user
      order.save!
    end
  end

  describe 'POST create' do
    describe 'json' do
      it 'rejects when not logged in' do
        post :create, order_id: @order.id, user_id: @user.id, name: 'Name', price_cents: 14, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in @user
        post :create, order_id: @order.id, user_id: @user.id, name: 'Name', price_cents: 14, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns errors' do
        sign_in @user
        post :create, order_id: @order.id, user_id: @user.id, price_cents: 14, format: :json
        expect(response).to have_http_status(422)
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
    describe 'json' do
      it 'rejects when not logged in' do
        put :update, order_id: @order.id, id: @dish.id, user_id: @user.id, name: 'Name', price: 13, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in @user
        put :update, order_id: @order.id, id: @dish.id, user_id: @user.id, name: 'Name', price: 13, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns errors' do
        sign_in @user
        put :update, order_id: @order.id, id: @dish.id, user_id: @user.id, name: '', price: 13, format: :json
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

  describe 'POST copy' do
    before do
      @other_user = create(:other_user)
      @dish = build(:dish) do |dish|
        dish.user = @user
        dish.order = @order
      end
      @dish.save
    end
    describe 'json' do
      it 'copies a new dish' do
        sign_in @other_user
        expect {
          post :copy, order_id: @order.id, id: @dish.id, format: :json
        }.to change(Dish, :count).by(1)
      end
      it 'doesnt copy a dish if a user already has a dish in that order' do
        sign_in @user
        expect {
          post :copy, order_id: @order.id, id: @dish.id, format: :json
        }.to_not change(Dish, :count)
      end
      it 'rejects when not logged in' do
        post :copy, order_id: @order.id, id: @dish.id, format: :json
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET show' do
    before do
      @dish = build(:dish) do |dish|
        dish.user = @user
        dish.order = @order
      end
      @dish.save!
    end
    describe 'json' do
      it 'rejects when not logged in' do
        get :show, order_id: @order.id, id: @dish.id, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in @user
        get :show, order_id: @order.id, id: @dish.id, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end
end
