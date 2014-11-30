require 'spec_helper'

describe DashboardController, type: :controller do
  describe 'GET :index' do
    describe 'html' do
      it 'shows dasboard to signed in user' do
        @user = create(:user)
        sign_in @user
        get :index, format: :html
        expect(response).to render_template :index
      end
      it 'redirects not signed in user to root' do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end
end