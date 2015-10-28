require 'spec_helper'

describe Api::InvitationsController, type: :controller do
  let(:company) { create :company }
  let(:user) { create :user, company: company, company_admin: true }
  let(:other_user) { create :other_user, company: company }
  let(:invitation) { create :invitation, company: company }
  describe 'POST :create' do
    describe 'json' do
      it 'rejects when not logged in' do
        post_invitation should_login: false
        expect(response).to have_http_status(:unauthorized)
      end
      it 'rejects a non-admin user' do
        sign_in other_user
        post :create, email: 'test@user.com', format: :json
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
        it 'sends an email' do
          expect do
            post_invitation
          end.to change(ActionMailer::Base.deliveries, :count).by(1)
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
        let!(:taken_invitation) do
          create :invitation, company: company, email: 'test@user.com'
        end
        it 'returns unprocessable entity' do
          post_invitation
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
      context 'with email taken by an invitation outside company' do
        let!(:taken_invitation) do
          create :invitation, email: 'test@user.com'
        end
        it 'returns success' do
          post_invitation
          expect(response).to have_http_status(:success)
        end
        it 'creates an authorized invitation' do
          expect do
            post_invitation
          end.to change(Invitation.where(authorized: true), :count).by(1)
        end
        it 'sends an email' do
          expect do
            post_invitation
          end.to change(ActionMailer::Base.deliveries, :count).by(1)
        end
      end
      context 'with missing data' do
        it 'returns unprocessable entity' do
          post_invitation(email: '')
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
      def post_invitation(should_login: true, email: 'test@user.com')
        sign_in user if should_login
        post :create, email: email, format: :json
      end
    end
  end

  describe 'DELETE :destroy' do
    describe 'json' do
      it 'rejects when not logged in' do
        delete_invitation(should_login: false)
        expect(response).to have_http_status(:unauthorized)
      end
      it 'rejects a non-admin user' do
        sign_in other_user
        delete :destroy, id: invitation.id
        expect(response).to have_http_status(:unauthorized)
      end
      context 'with proper data' do
        it 'returns a success' do
          delete_invitation
          expect(response).to have_http_status(:no_content)
        end
        it 'deletes the invitation' do
          invitation # to make sure the invitation is created
          expect do
            delete_invitation
          end.to change(Invitation, :count).by(-1)
        end
      end
    end

    def delete_invitation(should_login: true)
      sign_in user if should_login
      delete :destroy, id: invitation.id, format: :json
    end
  end
end
