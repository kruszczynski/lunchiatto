require 'spec_helper'

describe Api::DishesController, :type => :controller do
  let(:company) { create(:company) }
  let(:user) { create :user, company: company }
  let(:other_user) { create :other_user, company: company }
  let(:order) { create :order, user: user, company: company }

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
      it "creates a dish" do
        sign_in user
        expect {
          post :create, order_id: order.id, user_id: user.id, name: 'Name', price_cents: 14, format: :json
        }.to change(Dish, :count).by(1)
      end
      it 'returns errors' do
        sign_in user
        post :create, order_id: order.id, user_id: user.id, price_cents: 14, format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT update' do
    let(:dish) {create :dish, user: user, order: order}
    let(:other_dish) {create :dish, user: other_user, order: order}
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
      it 'does not allow others to edit' do
        sign_in other_user
        put :update, order_id: order.id, id: dish.id, user_id: user.id, name: 'Name', price: 13, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'allows the orderer to edit once ordered' do
        order.ordered!
        sign_in user
        put :update, order_id: order.id, id: other_dish.id, user_id: user.id, name: "Fame in the game", price: 15, format: :json
        expect(response).to have_http_status(200)
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
      it "rejects request from a different user" do
        sign_in other_user
        delete :destroy, order_id: order.id, id: dish.id, format: :json
        expect(response).to have_http_status(:unauthorized)
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
