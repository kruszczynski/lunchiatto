require 'spec_helper'

describe App::DashboardController, type: :controller do
  describe 'GET :index' do
    describe 'html' do
      let(:user) {create(:user)}
      it 'shows dasboard to signed in user' do
        sign_in user
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