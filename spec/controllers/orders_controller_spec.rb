require 'spec_helper'

describe OrdersController, :type => :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  describe 'POST create' do
    it 'creates an order' do
      sign_in user
      expect {
        post :create, user_id: user.id, from: 'A restaurant', format: :json
      }.to change(Order, :count)
    end
    describe 'json' do
      it 'rejects when not logged in' do
        post :create, user_id: user.id, from: 'A restaurant', format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns success' do
        sign_in user
        post :create, user_id: user.id, from: 'A restaurant', format: :json
        expect(response).to have_http_status(:success)
      end
      it 'returns errors' do
        sign_in user
        post :create, from: 'A restaurant', format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT update' do
    let(:order) { create :order, user: user }
    describe 'json' do
      it 'rejects when not logged in' do
        put :update, id: order.id, format: :json
        expect(response).to have_http_status(401)
      end
      it 'returns errors when delivered' do
        order.delivered!
        sign_in user
        put :update, id: order.id, from: 'Good Food INC', format: :json
        expect(response).to have_http_status(422)
      end
      it 'returns errors when ordered and a different user' do
        order.ordered!
        sign_in other_user
        put :update, id: order.id, from: 'Good Food INC', format: :json
        expect(response).to have_http_status(422)
      end
      it 'allows when ordered and proper user' do
        order.ordered!
        sign_in user
        put :update, id: order.id, from: "KFC Remote", format: :json
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
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET show' do
    let(:order) { create :order, user: user }
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
    let(:order) { create :order, user: user }
    describe 'json' do
      it 'rejects when not logged in' do
        put :change_status, id: order.id, format: :json
        expect(response).to have_http_status(401)
      end
      describe "order in_progress" do
        it 'returns success for payer' do
          sign_in user
          put :change_status, id: order.id, format: :json
          expect(response).to have_http_status(:success)
        end
        it 'returns errors for other user' do
          sign_in other_user
          put :change_status, id: order.id, format: :json
          expect(response).to have_http_status(422)
        end
      end
      describe "order ordered" do
        before do
          order.ordered!
        end
        it 'returns success for payer' do
          sign_in user
          put :change_status, id: order.id, format: :json
          expect(response).to have_http_status(:success)
        end
        it 'returns errors for other user' do
          sign_in other_user
          put :change_status, id: order.id, format: :json
          expect(response).to have_http_status(422)
        end
      end
      describe "order delivered" do
        before do
          order.delivered!
        end
        it 'returns errors for payer' do
          sign_in user
          put :change_status, id: order.id, format: :json
          expect(response).to have_http_status(422)
        end
        it 'returns errors for other user' do
          sign_in other_user
          put :change_status, id: order.id, format: :json
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  describe 'GET :index' do
    let!(:order) { create :order, user: user, date: Date.today }
    let!(:order2) { create :order, user: user, date: Date.yesterday }
    let!(:order3) { create :order, user: user, date: 2.days.ago }
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
        expect(assigns(:orders).count).to eq(3)
      end
    end
  end

  describe 'GET :latest' do
    let(:order) { create :order, user: user }
    describe 'json' do
      it 'rejects when not logged in' do
        get :latest, format: :json
        expect(response).to have_http_status(401)
      end
      it 'renders json' do
        sign_in user
        get :latest, format: :json
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE :destroy" do
    let!(:order) { create :order, user: user }
    describe "json" do
      it 'rejects when not logged in' do
        delete :destroy, id: order.id, format: :json
        expect(response).to have_http_status(401)
      end
      it "rejects when order ordered" do
        order.ordered!
        sign_in user
        delete :destroy, id: order.id, format: :json
        expect(response).to have_http_status(422)
      end
      it "rejects when order delivered" do
        order.delivered!
        sign_in user
        delete :destroy, id: order.id, format: :json
        expect(response).to have_http_status(422)
      end
      describe "order in progress" do
        it "doesn't allow others to delete" do
          sign_in other_user
          delete :destroy, id: order.id, format: :json
          expect(response).to have_http_status(422)
        end
        describe "when payer" do
          it "allows payer to delete" do
            sign_in user
            delete :destroy, id: order.id, format: :json
            expect(response).to have_http_status(200)
          end
          it "deletes the order" do
            sign_in user
            expect {
              delete :destroy, id: order.id, format: :json
            }.to change{Order.count}.by(-1)
          end
        end
      end
    end
  end
end