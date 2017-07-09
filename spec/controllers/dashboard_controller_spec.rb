# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe 'GET :index' do
    describe 'html' do
      let(:user) { create(:user) }

      it 'redirects not signed in user to root' do
        get :index
        expect(response).to redirect_to root_path
      end

      it 'renders SPA scaffold to signed in user' do
        sign_in user
        get :index, format: :html
        expect(response).to render_template :index
      end

      it 'is success' do
        sign_in user
        get :index, format: :html
        expect(response).to have_http_status(200)
      end
    end
  end
end
