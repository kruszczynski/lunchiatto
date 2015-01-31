require 'spec_helper'

describe PagesController, type: :controller do
  let(:user) {create(:user)}

  describe 'GET #index' do
    it 'renders index page' do
      get :index
      expect(response).to render_template :index
    end

    it 'redirects logged in user to dashboard' do
      sign_in user
      get :index
      expect(response).to redirect_to app_dashboard_path
    end
  end
end