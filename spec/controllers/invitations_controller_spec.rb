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
end