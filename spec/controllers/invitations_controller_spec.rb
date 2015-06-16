require "spec_helper"

describe InvitationsController, type: :controller do
  let(:company) { create :company }
  let(:user) { create :user, company: company, company_admin: true }
  let(:other_user) { create :other_user, company: company }
  let(:invitation) { create :invitation, company: company }
  describe "GET :show" do
    describe "html" do
      it "redirects logged in user to dashboard" do
        sign_in user
        get_invitation
        expect(response).to redirect_to orders_today_path
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

  describe "POST :create" do
    describe "with proper data" do
      let!(:admin) { create :user, admin: true }
      it "sends an email" do
        expect {
          post_request
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it "is a success" do
        post_request
        expect(response).to have_http_status(:success)
      end

      it "creates an invitiation" do
        expect {
          post_request
        }.to change(Invitation, :count).by(1)
      end
    end

    describe "if there's no email" do
      it "doesn't send an email" do
        expect {
          post_request email: ""
        }.to_not change(ActionMailer::Base.deliveries, :count)
      end
      it "returns unprocessable" do
        post_request email: ""
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe "if there's a user for this email" do
      let!(:taken_user) { create :user, email: "party@mate.gate" }
      it "doesn't send an email" do
        expect {
          post_request
        }.to_not change(ActionMailer::Base.deliveries, :count)
      end
      it "returns unprocessable" do
        post_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe "if there's an invitation for this email" do
      let!(:taken_invitation) { create :invitation, email: "party@mate.gate" }
      it "doesn't send an email" do
        expect {
          post_request
        }.to_not change(ActionMailer::Base.deliveries, :count)
      end
      it "returns unprocessable" do
        post_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    def post_request(email: "party@mate.gate")
      post :create, invitation: {email: email}, format: :json
    end
  end
end