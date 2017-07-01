# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  describe 'POST create' do
    let(:call) do
      post :create, params: {user_id: user.id, from: 'A bistro'}, format: :json
    end

    it 'creates an order' do
      sign_in user
      expect { call }.to change(Order, :count)
    end
    describe 'json' do
      it 'rejects when not logged in' do
        post :create,
             params: {user_id: user.id, from: 'A bistro'},
             format: :json
        expect(response).to have_http_status(401)
      end

      context 'when an order from this restaurant already exists' do
        let!(:order) { create(:order, from: 'A bistro', user: user) }

        it 'returns unprocessable' do
          sign_in user
          call
          expect(response).to have_http_status(422)
        end

        it "doesn't create the order in such case" do
          sign_in user
          expect { call }.not_to change(Order, :count)
        end
      end

      it 'returns success' do
        sign_in user
        call
        expect(response).to have_http_status(:success)
      end

      it 'returns success with existing order' do
        create(:order, user: user)
        sign_in user
        call
        expect(response).to have_http_status(:success)
      end

      context 'incomplete data' do
        let(:call) do
          post :create, params: {from: 'A bistro'}, format: :json
        end

        it 'returns errors' do
          sign_in user
          call
          expect(response).to have_http_status(422)
        end

        it "doesn't create an order" do
          sign_in user
          expect { call }.not_to change(Order, :count)
        end
      end
    end
  end

  describe 'PUT update' do
    let(:order) { create(:order, user: user) }

    describe 'json' do
      it 'rejects when not logged in' do
        put :update, params: {id: order.id}, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized when delivered' do
        order.delivered!
        sign_in user
        put :update, params: {id: order.id, from: 'Good Food'}, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized when ordered and a different user' do
        order.ordered!
        sign_in other_user
        put :update, params: {id: order.id, from: 'Good Food'}, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'allows when ordered and proper user' do
        order.ordered!
        sign_in user
        put :update, params: {id: order.id, from: 'KFC Remote'}, format: :json
        expect(response).to have_http_status(:success)
      end

      it 'allows when in_progress' do
        sign_in user
        update_params = {id: order.id, user_id: other_user.id}
        put :update, params: update_params, format: :json
        expect(response).to have_http_status(:success)
      end

      it 'returns errors' do
        sign_in user
        put :update, params: {id: order.id, from: ''}, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET show' do
    let(:order) { create(:order, user: user) }

    describe 'json' do
      it 'rejects when not logged in' do
        get :show, params: {id: order.id}, format: :json
        expect(response).to have_http_status(401)
      end

      it 'returns success' do
        sign_in user
        get :show, params: {id: order.id}, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PUT change_status' do
    let(:order) { create(:order, user: user) }

    describe 'json' do
      it 'rejects when not logged in' do
        put :change_status,
            params: {id: order.id, status: 'ordered'},
            format: :json
        expect(response).to have_http_status(401)
      end

      context 'order in_progress' do
        it 'returns success for orderer' do
          put_status(status: 'ordered')
          expect(response).to have_http_status(:success)
        end

        it 'returns success for other user' do
          sign_in other_user
          put_status(status: 'ordered')
          expect(response).to have_http_status(:success)
        end
      end

      describe 'order ordered' do
        before { order.ordered! }

        it 'returns success to delivered' do
          put_status(status: 'delivered')
          expect(response).to have_http_status(:success)
        end

        it 'returns success to in progress' do
          put_status(status: 'in_progress')
          expect(response).to have_http_status(:success)
        end
      end
      describe 'order delivered' do
        before { order.delivered! }

        it 'returns unauthorized' do
          put_status(status: 'ordered')
          expect(response).to have_http_status(401)
        end
      end

      describe 'if save fails' do
        before do
          order.ordered!
          order.update_column(:user_id, nil)
          create(:dish, order: order, user: other_user, name: 'Ye', price: '12')
        end

        it 'rolls back Payments' do
          expect { put_status(status: 'delivered') }
            .not_to change(Payment, :count)
        end
      end

      def put_status(status: nil)
        sign_in user
        put :change_status,
            params: {id: order.id, status: status},
            format: :json
      end
    end
  end

  describe 'GET :index' do
    let!(:order) { create(:order, user: user, date: Time.zone.today) }
    let!(:order2) { create(:order, user: user, date: 1.day.ago) }
    let!(:order3) { create(:order, user: user, date: 2.days.ago) }

    describe 'json' do
      it 'rejects when not logged in' do
        get :index, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns json' do
        sign_in user
        get :index, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns all orders' do
        sign_in user
        get :index, format: :json
        parsed_body = JSON.parse(response.body)
        expect(parsed_body.count).to eq(3)
      end
    end
  end

  describe 'GET :latest' do
    describe 'json' do
      it 'rejects when not logged in' do
        get :latest, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns an empty collection' do
        sign_in user
        get :latest, format: :json
        expect(JSON.parse(response.body).size).to be(0)
      end
      describe 'with orders' do
        let!(:order) { create(:order, user: user) }
        let!(:order2) { create(:order, user: user, from: 'Another Place') }
        let!(:order3) { create(:order, user: user, from: 'Pizza Place') }
        let!(:order4) { create(:order, user: user, date: 1.day.ago) }

        it 'renders json' do
          sign_in user
          get :latest, format: :json
          expect(response).to have_http_status(:success)
        end
        it "returns today's orders" do
          sign_in user
          get :latest, format: :json
          expect(JSON.parse(response.body).size).to be(3)
        end
      end
    end
  end

  describe 'DELETE :destroy' do
    let!(:order) { create :order, user: user }

    describe 'json' do
      it 'rejects when not logged in' do
        delete :destroy, params: {id: order.id}, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'rejects when order ordered' do
        order.ordered!
        sign_in user
        delete :destroy, params: {id: order.id}, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'rejects when order delivered' do
        order.delivered!
        sign_in user
        delete :destroy, params: {id: order.id}, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      describe 'order in progress' do
        it "doesn't allow others to delete" do
          sign_in other_user
          delete :destroy, params: {id: order.id}, format: :json
          expect(response).to have_http_status(:unauthorized)
        end
        describe 'when payer' do
          it 'allows payer to delete' do
            sign_in user
            delete :destroy, params: {id: order.id}, format: :json
            expect(response).to have_http_status(:no_content)
          end
          it 'deletes the order' do
            sign_in user
            expect do
              delete :destroy, params: {id: order.id}, format: :json
            end.to change { Order.count }.by(-1)
          end
        end
      end
    end
  end
end
