require 'spec_helper'

describe Users::OmniauthCallbacksController, type: :controller do
  describe 'GET google_oauth2' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user] # If using Devise
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2_non_codequest]
    end
    it 'redirects to index' do
      get :google_oauth2
      expect(response).to redirect_to(root_path)
    end
    it 'shouldnt create a user' do
      expect {
        get :google_oauth2
      }.to_not change(User, :count)
    end
    context 'with success' do
      before do
        request.env["devise.mapping"] = Devise.mappings[:user] # If using
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2_codequest]
        User.create(email: "test@codequest.com")
      end

      it 'redirects to new_company_path if user has no company' do
        get :google_oauth2
        expect(response).to redirect_to(new_company_url)
      end
    end
    context "when user does not exist" do
      before do
        request.env["devise.mapping"] = Devise.mappings[:user] # If using
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2_codequest]
      end
      it 'redirects to index' do
        get :google_oauth2
        expect(response).to redirect_to(root_path)
      end
    end
  end
end