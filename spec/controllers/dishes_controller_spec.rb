require 'spec_helper'

describe DishesController, :type => :controller do
  let(:user) {create(:user)}
  let(:order) {create :order, user: user}

  describe 'POST create' do
    describe 'json' do
      it 'rejects when not logged in' do
        post :create, order_id: order.id, user_id: user.id, name: 'Name', price_cents: 14, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in user
        post :create, order_id: order.id, user_id: user.id, name: 'Name', price_cents: 14, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns errors' do
        sign_in user
        post :create, order_id: order.id, user_id: user.id, price_cents: 14, format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'POST update' do
    let(:dish) {create :dish, user: user, order: order}
    describe 'json' do
      it 'rejects when not logged in' do
        put :update, order_id: order.id, id: dish.id, user_id: user.id, name: 'Name', price: 13, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in user
        put :update, order_id: order.id, id: dish.id, user_id: user.id, name: 'Name', price: 13, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns errors' do
        sign_in user
        put :update, order_id: order.id, id: dish.id, user_id: user.id, name: '', price: 13, format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:dish) {create :dish, user: user, order: order}
    describe 'json' do
      it 'rejects when not logged in' do
        delete :destroy, order_id: order.id, id: dish.id, format: :json
        expect(response).to have_http_status(401)
      end
      it 'decrements the dishes count' do
        sign_in user
        expect {
          delete :destroy, order_id: order.id, id: dish.id, format: :json
        }.to change(Dish, :count).by(-1)
      end
      it 'is success' do
        sign_in user
        delete :destroy, order_id: order.id, id: dish.id, format: :json
        expect(response).to have_http_status(:success)
        expect(response.body).to eq({status: 'success'}.to_json)
      end
    end
  end

  describe 'POST copy' do
    let(:other_user) {create(:other_user)}
    let!(:dish) {create :dish, user: user, order: order}
    describe 'json' do
      it 'copies a new dish' do
        sign_in other_user
        expect {
          post :copy, order_id: order.id, id: dish.id, format: :json
        }.to change(Dish, :count).by(1)
      end
      it 'doesnt copy a dish if a user already has a dish in that order' do
        sign_in user
        expect {
          post :copy, order_id: order.id, id: dish.id, format: :json
        }.to_not change(Dish, :count)
      end
      it 'rejects when not logged in' do
        post :copy, order_id: order.id, id: dish.id, format: :json
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET show' do
    let(:dish) {create :dish, user: user, order: order}
    describe 'json' do
      it 'rejects when not logged in' do
        get :show, order_id: order.id, id: dish.id, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in user
        get :show, order_id: order.id, id: dish.id, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end
end
