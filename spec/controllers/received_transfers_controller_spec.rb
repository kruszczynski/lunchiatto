require "spec_helper"

describe ReceivedTransfersController, type: :controller do
  let(:user) {create :user}
  let(:other_user) {create :other_user}
  let!(:transfer) {create(:transfer, from: user, to: other_user)}
  let!(:other_transfer) {create(:transfer, from: user, to: other_user)}
  let!(:yet_another_transfer) {create(:transfer, from: other_user, to: other_user)}

  describe "GET :index" do
    it "is success" do
      sign_in other_user
      get :index, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to be(3)
    end
    it "rejects when not logged in" do
      get :index, format: :json
      expect(response).to have_http_status(401)
    end
    it "returns transfers from user" do
      sign_in other_user
      get :index, user_id: user.id, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to be(2)
    end
    it "returns transfers from other_user" do
      sign_in other_user
      get :index, user_id: other_user.id, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to be(1)
    end
  end
end
