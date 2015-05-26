require "spec_helper"

describe InvitationsController, type: :controller do
  let(:company) { create :company }
  let(:user) { create :user, company: company, company_admin: true }
  let(:other_user) { create :other_user, company: company }
  let(:invitation) { create :invitation, company: company }
  describe "POST :create" do
    describe "json" do
      it "rejects when not logged in" do
        post_invitation should_login: false
        expect(response).to have_http_status(401)
      end
      it "rejects a non-admin user" do
        sign_in other_user
        post :create, email: "test@user.com", format: :json
        expect(response).to have_http_status(401)
      end
      context "with good data" do
        it "returns a success" do
          post_invitation
          expect(response).to have_http_status(200)
        end
        it "creates an invitation" do
          expect {
            post_invitation
          }.to change(Invitation, :count).by(1)
        end
        it "sends an email" do
          expect {
            post_invitation
          }.to change(ActionMailer::Base.deliveries, :count).by(1)
        end
      end
      context "with email taken by a user" do
        let!(:taken_user) { create :user, email: "test@user.com" }
        it "returns unprocessable entity" do
          post_invitation
          expect(response).to have_http_status(422)
        end
      end
      context "with email taken by an invitation" do
        let!(:taken_invitation) { create :invitation, company: company, email: "test@user.com" }
        it "returns unprocessable entity" do
          post_invitation
          expect(response).to have_http_status(422)
        end
      end
      context "with missing data" do
        it "returns unprocessable entity" do
          post_invitation(email: "")
          expect(response).to have_http_status(422)
        end
      end
      def post_invitation(should_login: true, email: "test@user.com")
        sign_in user if should_login
        post :create, email: email, format: :json
      end
    end
  end

  describe "DELETE :destroy" do
    describe "json" do
      it "rejects when not logged in" do
        delete_invitation(should_login: false)
        expect(response).to have_http_status(401)
      end
      it "rejects a non-admin user" do
        sign_in other_user
        delete :destroy, id: invitation.id
        expect(response).to have_http_status(401)
      end
      context "with proper data" do
        it "returns a success" do
          delete_invitation
          expect(response).to have_http_status(200)
        end
        it "deletes the invitation" do
          invitation #to make sure the invitation is created
          expect {
            delete_invitation
          }.to change(Invitation, :count).by(-1)
        end
      end
    end

    def delete_invitation(should_login: true)
      sign_in user if should_login
      delete :destroy, id: invitation.id, format: :json
    end
  end

  describe "GET :show" do
    describe "html" do
      it "redirects logged in user to dashboard" do
        sign_in user
        get_invitation
        expect(response).to redirect_to app_orders_today_path
      end
      it "is a success" do
        get_invitation
        expect(response).to have_http_status(:success)
      end
      it "is a renders template" do
        get_invitation
        expect(response).to render_template(:show)
      end
      it "assigns an invitation" do
        get_invitation
        expect(assigns(:invitation)).to be_an(Invitation)
      end
      it "redirects to root if there's no such invitation" do
        get :show, id: invitation.id+1, format: :html
        expect(response).to redirect_to root_path
      end
    end

    def get_invitation
      get :show, id: invitation.id, format: :html
    end
  end
end