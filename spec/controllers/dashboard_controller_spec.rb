require "spec_helper"

describe DashboardController, type: :controller do
  describe "GET :index" do
    describe "html" do
      let(:user) { create(:user) }
      let(:company) { create(:company) }

      it "redirects not signed in user to root" do
        get :index
        expect(response).to redirect_to root_path
      end

      it "redirects to new company url when user has no company" do
        sign_in user
        get :index, format: :html
        expect(response).to redirect_to(new_company_url)
      end

      context "when user has a company" do
        before do
          user.company = company
          user.save!
        end

        it "renders SPA scaffold to signed in user" do
          sign_in user
          get :index, format: :html
          expect(response).to render_template :index
        end

        it "is success" do
          sign_in user
          get :index, format: :html
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end