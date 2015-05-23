require "spec_helper"

describe Users::OmniauthCallbacksController, type: :controller do
  describe "GET google_oauth2" do
    context "with success" do
      before do
        request.env["devise.mapping"] = Devise.mappings[:user] 
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2_codequest]
        User.create(email: "test@codequest.com", provider: "google_oauth2", uid: "123545")
      end

      it "redirects to new_company_path if user has no company" do
        get :google_oauth2
        expect(response).to redirect_to(new_company_url)
      end
    end
    context "works for non-codequest users" do
      before do
        request.env["devise.mapping"] = Devise.mappings[:user] 
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2_non_codequest]
        User.create(email: "test@email.com", provider: "google_oauth2", uid: "123545")
      end

      it "redirects to new_company_path if user has no company" do
        get :google_oauth2
        expect(response).to redirect_to(new_company_url)
      end
    end
    context "when user does not exist" do
      before do
        request.env["devise.mapping"] = Devise.mappings[:user] 
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2_codequest]
      end
      it "redirects to index" do
        get :google_oauth2
        expect(response).to redirect_to(root_path)
      end
    end
    context "when user is invited" do
      let(:company) { create :company }
      let!(:invitation) { create :invitation, company: company, email: "test@codequest.com" }
      before do
        request.env["devise.mapping"] = Devise.mappings[:user] 
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2_codequest]
      end
      it "redirects" do
        get :google_oauth2
        expect(response).to redirect_to(new_company_url)
      end
      it "creates user" do
        expect {
          get :google_oauth2
        }.to change(User, :count).by(1)
      end
      it "deletes the invitation" do
        expect {
          get :google_oauth2
        }.to change(Invitation, :count).by(-1)
      end
    end
  end
end