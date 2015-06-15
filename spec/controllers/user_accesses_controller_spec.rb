require "spec_helper"

describe UserAccessesController, type: :controller do
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
      post :create, email: email, format: :json
    end
  end
end