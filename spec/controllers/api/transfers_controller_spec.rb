require 'spec_helper'

describe Api::TransfersController, type: :controller do
  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let(:transfer) { create :transfer, from: user, to: other_user }

  describe 'POST to create' do
    describe 'json' do
      it 'creates a transfer' do
        sign_in other_user
        expect do
          post :create, to_id: user.id, amount: 14, format: :json
        end.to change(Transfer, :count).by(1)
      end
      it 'sends an email' do
        sign_in other_user
        expect do
          post :create, to_id: user.id, amount: 14, format: :json
        end.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
      it 'rejects when not logged in' do
        post :create, to_id: user.id, amount: 14, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns error when no user' do
        sign_in other_user
        post :create, amount: 14, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT to accept' do
    describe 'json' do
      it 'rejects when current_user is not the receiver' do
        sign_in user
        put :accept, id: transfer.id, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'sends an email' do
        sign_in other_user
        expect do
          put :accept, id: transfer.id, format: :json
        end.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
      it 'rejects not pending' do
        transfer.accepted!
        sign_in other_user
        put :accept, id: transfer.id, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'is success' do
        sign_in other_user
        put :accept, id: transfer.id, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'rejects when not logged in' do
        put :accept, id: transfer.id, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT to reject' do
    describe 'json' do
      it 'redirects to root if user is not the receiver of transfer' do
        sign_in user
        put :reject, id: transfer.id, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
      it 'sends an email' do
        sign_in other_user
        expect do
          put :reject, id: transfer.id, format: :json
        end.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
      it 'is success' do
        sign_in other_user
        put :reject, id: transfer.id, format: :json
        expect(response).to have_http_status(:success)
      end
      it 'rejects when not logged in' do
        put :reject, id: transfer.id, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
