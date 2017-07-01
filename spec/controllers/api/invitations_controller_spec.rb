# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::InvitationsController, type: :controller do
  include ActiveJob::TestHelper
  let(:user) { create(:user, admin: true) }
  let(:other_user) { create(:other_user) }
  let(:invitation) { create(:invitation) }

  describe 'GET :index' do
    let(:call) { get :index, format: :json }

    it 'rejects when not logged in' do
      call
      expect(response).to have_http_status(:unauthorized)
    end

    it 'rejects a non-admin user' do
      sign_in other_user
      call
      expect(response).to have_http_status(:unauthorized)
    end

    context 'with admin user' do
      let!(:invitations) do
        (1..5).map { |n| create(:invitation, email: "test#{n}@test.com") }
      end

      before do
        sign_in user
        call
      end

      it 'returns a success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns invitations' do
        parsed_response = JSON.parse(response.body)
        expected = invitations.map { |i| {'email' => i.email, 'id' => i.id} }
        expect(parsed_response).to eq(expected)
      end

      it 'return 5 invitations' do
        expect(JSON.parse(response.body).size).to eq(5)
      end
    end
  end
  describe 'POST :create' do
    it 'rejects when not logged in' do
      post :create, params: {email: 'test@user.com'}, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
    it 'rejects a non-admin user' do
      sign_in other_user
      post :create, params: {email: 'test@user.com'}, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
    context 'with good data' do
      it 'returns a success' do
        post_invitation
        expect(response).to have_http_status(:success)
      end
      it 'creates an invitation' do
        expect do
          post_invitation
        end.to change(Invitation, :count).by(1)
      end
      it 'creates an authorized invitation' do
        expect do
          post_invitation
        end.to change(Invitation.where(authorized: true), :count).by(1)
      end
      it 'enqueues email' do
        expect do
          post_invitation
        end.to change(enqueued_jobs, :count).by(1)
      end
    end
    context 'with email taken by a user' do
      let!(:taken_user) { create :user, email: 'test@user.com' }
      it 'returns unprocessable entity' do
        post_invitation
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
    context 'with email taken by an invitation within company' do
      before do
        create(:invitation, email: 'test@user.com')
      end
      it 'returns unprocessable entity' do
        post_invitation
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
    context 'with missing data' do
      it 'returns unprocessable entity' do
        post_invitation(email: '')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
    def post_invitation(email: 'test@user.com')
      sign_in user
      post(:create, params: {email: email}, format: :json)
    end
  end

  describe 'DELETE :destroy' do
    let(:call) { delete :destroy, params: {id: invitation.id}, format: :json }

    it 'rejects when not logged in' do
      call
      expect(response).to have_http_status(:unauthorized)
    end

    context 'with other user' do
      it 'rejects a non-admin user' do
        sign_in other_user
        call
        expect(response).to have_http_status(:unauthorized)
      end
    end # context 'with other user'

    context 'with user' do
      before { sign_in user }
      it 'returns a success' do
        call
        expect(response).to have_http_status(:no_content)
      end
      it 'deletes the invitation' do
        invitation # to make sure the invitation is created
        expect do
          call
        end.to change(Invitation, :count).by(-1)
      end
    end # context 'with proper data'
  end # describe 'DELETE :destroy'
end # RSpec.describe Api::InvitationsController
