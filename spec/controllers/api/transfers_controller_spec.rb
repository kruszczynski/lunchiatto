# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::TransfersController, type: :controller do
  include ActiveJob::TestHelper
  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let!(:transfer) { create :transfer, from: user, to: other_user }

  describe 'GET to index' do
    let!(:other_transfer) { create(:transfer, from: user, to: other_user) }
    let!(:third_transfer) do
      create(:transfer, from: other_user, to: other_user)
    end
    let!(:forth_transfer) { create(:transfer, from: user, to: user) }

    shared_examples 'transfers index' do |type, expected_count, user|
      it "returns #{user} transfers" do
        user_id = user ? send(user).id : nil
        get :index, params: {user_id: user_id, type: type}, format: :json
        expect(JSON.parse(response.body).length).to eq(expected_count)
      end
    end # shared_examples 'transfers index'

    it 'rejects when not logged in' do
      get :index, format: :json
      expect(response).to have_http_status(401)
    end

    context 'received transfers' do
      before { sign_in other_user }
      it_behaves_like 'transfers index', 'received', 3
      it_behaves_like 'transfers index', 'received', 2, :user
      it_behaves_like 'transfers index', 'received', 1, :other_user
    end # context 'received transfers'

    context 'submitted transfers' do
      before { sign_in user }
      it_behaves_like 'transfers index', 'submitted', 3
      it_behaves_like 'transfers index', 'submitted', 2, :other_user
      it_behaves_like 'transfers index', 'submitted', 1, :user
    end # context 'submitted transfers'
  end # describe 'GET to index'

  describe 'POST to create' do
    it 'creates a transfer' do
      sign_in other_user
      expect do
        post :create, params: {to_id: user.id, amount: 14}, format: :json
      end.to change(Transfer, :count).by(1)
    end

    it 'enqueues an email' do
      sign_in other_user
      expect do
        post :create, params: {to_id: user.id, amount: 14}, format: :json
      end.to change(enqueued_jobs, :count).by(1)
    end

    it 'rejects when not logged in' do
      post :create, params: {to_id: user.id, amount: 14}, format: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns error when no user' do
      sign_in other_user
      post :create, params: {amount: 14}, format: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end # describe 'POST to create'

  describe 'PUT to accept' do
    it 'rejects when current_user is not the receiver' do
      sign_in user
      put :accept, params: {id: transfer.id}, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
    it 'enqueues an email' do
      sign_in other_user
      expect do
        put :accept, params: {id: transfer.id}, format: :json
      end.to change(enqueued_jobs, :count).by(1)
    end
    it 'is success' do
      sign_in other_user
      put :accept, params: {id: transfer.id}, format: :json
      expect(response).to have_http_status(:success)
    end

    it 'rejects not pending' do
      transfer.accepted!
      sign_in other_user
      put :accept, params: {id: transfer.id}, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
    it 'rejects when not logged in' do
      put :accept, params: {id: transfer.id}, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end # describe 'PUT to accept'

  describe 'PUT to reject' do
    it 'redirects to root if user is not the receiver of transfer' do
      sign_in user
      put :reject, params: {id: transfer.id}, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
    it 'enqueues an email' do
      sign_in other_user
      expect do
        put :reject, params: {id: transfer.id}, format: :json
      end.to change(enqueued_jobs, :count).by(1)
    end
    it 'is success' do
      sign_in other_user
      put :reject, params: {id: transfer.id}, format: :json
      expect(response).to have_http_status(:success)
    end
    it 'rejects when not logged in' do
      put :reject, params: {id: transfer.id}, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end # describe 'PUT to reject'
end # RSpec.describe Api::TransfersController
