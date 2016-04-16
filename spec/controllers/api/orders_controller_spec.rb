# frozen_string_literal: true
require 'spec_helper'

describe Api::OrdersController, type: :controller do
  let(:company) { create :company }
  let(:other_company) { create :company, name: 'Other Company' }
  let(:user) { create :user, company: company }
  let(:other_user) { create :other_user, company: company }
  let(:other_company_user) do
    create :user, company: other_company,
                  name: 'Other',
                  email: 'other@other.com'
  end

  describe 'POST create' do
    it 'creates an order' do
      sign_in user
      expect do
        post :create, user_id: user.id, from: 'A restaurant', format: :json
      end.to change(Order, :count)
    end
    describe 'json' do
      it 'rejects when not logged in' do
        post :create, user_id: user.id, from: 'A restaurant', format: :json
        expect(response).to have_http_status(401)
      end
      describe 'when an order from this restaurant already exists' do
        let!(:order) do
          create :order, from: 'A restaurant', user: user, company: company
        end
        it 'returns unprocessable' do
          sign_in user
          post :create, user_id: user.id, from: 'A restaurant', format: :json
          expect(response).to have_http_status(422)
        end
        it "doesn't create the order in such case" do
          sign_in user
          expect do
            post :create, user_id: user.id, from: 'A restaurant', format: :json
          end.to_not change(Order, :count)
        end
      end
      it 'returns success' do
        sign_in user
        post :create, user_id: user.id, from: 'A restaurant', format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns success with existing order' do
        create :order, user: user, company: company
        sign_in user
        post :create, user_id: user.id, from: 'A restaurant', format: :json
        expect(response).to have_http_status(:success)
      end
      describe 'incomplete data' do
        it 'returns errors' do
          sign_in user
          post :create, from: 'A restaurant', format: :json
          expect(response).to have_http_status(422)
        end
        it "doesn't create an order" do
          sign_in user
          expect do
            post :create, from: 'A restaurant', format: :json
          end.to_not change(Order, :count)
        end
      end
    end
  end

  describe 'PUT update' do
    let(:order) { create :order, user: user, company: company }
    describe 'json' do
      it 'rejects when not logged in' do
        put :update, id: order.id, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns unauthorized when delivered' do
        order.delivered!
        sign_in user
        put :update, id: order.id, from: 'Good Food INC', format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns unauthorized when ordered and a different user' do
        order.ordered!
        sign_in other_user
        put :update, id: order.id, from: 'Good Food INC', format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'allows when ordered and proper user' do
        order.ordered!
        sign_in user
        put :update, id: order.id, from: 'KFC Remote', format: :json
        expect(response).to have_http_status(:success)
      end
      it 'allows when in_progress' do
        sign_in user
        put :update, id: order.id, user_id: other_user.id, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns errors' do
        sign_in user
        put :update, id: order.id, from: '', format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET show' do
    let(:order) { create :order, user: user, company: company }
    describe 'json' do
      it 'rejects when not logged in' do
        get :show, id: order.id, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in user
        get :show, id: order.id, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PUT change_status' do
    let(:order) { create :order, user: user, company: company }
    describe 'json' do
      it 'rejects when not logged in' do
        put :change_status, id: order.id, status: 'ordered', format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns unauthorized for other user' do
        sign_in other_user
        put :change_status, id: order.id, status: 'ordered', format: :json
        expect(response).to have_http_status(401)
      end
      describe 'order in_progress' do
        it 'returns success' do
          put_status(status: 'ordered')
          expect(response).to have_http_status(:success)
        end
      end
      describe 'order ordered' do
        before do
          order.ordered!
        end
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
        before do
          order.delivered!
        end
        it 'returns unauthorized' do
          put_status(status: 'ordered')
          expect(response).to have_http_status(401)
        end
      end

      def put_status(status: nil)
        sign_in user
        put :change_status, id: order.id, status: status, format: :json
      end
    end
  end

  describe 'GET :index' do
    let!(:order) do
      create :order, user: user, date: Time.zone.today, company: company
    end
    let!(:order2) do
      create :order, user: user, date: 1.day.ago, company: company
    end
    let!(:order3) do
      create :order, user: user, date: 2.days.ago, company: company
    end
    let!(:order4) do
      create :order, user: other_company_user, company: other_company
    end
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
      it 'returns all orders for the company' do
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
        let!(:order) { create :order, user: user, company: company }
        let!(:order2) do
          create :order, user: user, from: 'Another Place', company: company
        end
        let!(:order3) do
          create :order, user: user, from: 'Pizza Place', company: company
        end
        let!(:order4) do
          create :order, user: user, date: 1.day.ago, company: company
        end
        let!(:order5) do
          create :order, user: other_company_user,
                         from: 'Pizza Place',
                         company: other_company
        end
        it 'renders json' do
          sign_in user
          get :latest, format: :json
          expect(response).to have_http_status(:success)
        end
        it "returns today's orders from rhis company" do
          sign_in user
          get :latest, format: :json
          expect(JSON.parse(response.body).size).to be(3)
        end
      end
    end
  end

  describe 'DELETE :destroy' do
    let!(:order) { create :order, user: user, company: company }
    describe 'json' do
      it 'rejects when not logged in' do
        delete :destroy, id: order.id, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'rejects when order ordered' do
        order.ordered!
        sign_in user
        delete :destroy, id: order.id, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'rejects when order delivered' do
        order.delivered!
        sign_in user
        delete :destroy, id: order.id, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      describe 'order in progress' do
        it "doesn't allow others to delete" do
          sign_in other_user
          delete :destroy, id: order.id, format: :json
          expect(response).to have_http_status(:unauthorized)
        end
        describe 'when payer' do
          it 'allows payer to delete' do
            sign_in user
            delete :destroy, id: order.id, format: :json
            expect(response).to have_http_status(:no_content)
          end
          it 'deletes the order' do
            sign_in user
            expect do
              delete :destroy, id: order.id, format: :json
            end.to change { Order.count }.by(-1)
          end
        end
      end
    end
  end
end
