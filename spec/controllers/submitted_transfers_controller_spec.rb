require "spec_helper"

describe SubmittedTransfersController, type: :controller do
  before do
    @user = create :user
    @other_user = create :other_user
    @transfer = create(:transfer, from: @user, to: @other_user)
    @other_transfer = create(:transfer, from: @user, to: @other_user)
    @another_transfer = create(:transfer, from: @user, to: @user)
  end
  describe "GET :index" do
    it "is success" do
      sign_in @user
      get :index, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to be(3)
    end
    it "rejects when not logged in" do
      get :index, format: :json
      expect(response).to have_http_status(401)
    end
    it "shows on transfers to @other_user" do
      sign_in @user
      get :index, user_id: @other_user.id, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to be(2)
    end
    it "shows on transfers to @user" do
      sign_in @user
      get :index, user_id: @user.id, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to be(1)
    end
  end
end
