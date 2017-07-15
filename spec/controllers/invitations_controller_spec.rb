# frozen_string_literal: true
require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  include ActiveJob::TestHelper
  let(:user) { create :user }
  let(:other_user) { create :other_user }
  let(:invitation) { create :invitation }
  describe 'GET :show' do
    describe 'html' do
      it 'redirects logged in user to dashboard' do
        sign_in user
        request_invitation
        expect(response).to redirect_to orders_today_path
      end
      it 'is a success' do
        request_invitation
        expect(response).to have_http_status(:success)
      end
      it 'is a renders template' do
        request_invitation
        expect(response).to render_template(:show)
      end
      it 'assigns an invitation' do
        request_invitation
        expect(assigns(:invitation)).to be_an(Invitation)
      end
      it "redirects to root if there's no such invitation" do
        get :show, params: {id: invitation.id + 1}, format: :html
        expect(response).to redirect_to root_path
      end
    end

    def request_invitation
      get :show, params: {id: invitation.id}, format: :html
    end
  end
end
