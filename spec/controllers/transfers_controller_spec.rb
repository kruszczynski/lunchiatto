require "spec_helper"

describe TransfersController, type: :controller do
  describe "POST to create" do
    before do
      @user = create :user
      @other_user = create :other_user
    end
    describe "json" do
      it "creates a transfer" do
        sign_in @other_user
        expect{
          post :create, to_id: @user.id, amount: 14, format: :json
        }.to change(Transfer, :count).by(1)
      end
      it "sends an email" do
        sign_in @other_user
        expect{
          post :create, to_id: @user.id, amount: 14, format: :json
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
      it "rejects when not logged in" do
        post :create, to_id: @user.id, amount: 14, format: :json
        expect(response).to have_http_status(401)
      end
      it "returns error when no user" do
        sign_in @other_user
        post :create, amount: 14, format: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PUT to accept" do
    before do
      @user = create :user
      @other_user = create :other_user
      @transfer = build(:transfer) do |transfer|
        transfer.from = @user
        transfer.to = @other_user
      end
      @transfer.save!
    end
    describe "json" do
      it "rejects when current_user is not the receiver" do
        sign_in @user
        put :accept, id: @transfer.id, format: :json
        expect(response).to have_http_status(422)
      end
      it "rejects not pending" do
        @transfer.accepted!
        sign_in @other_user
        put :accept, id: @transfer.id, format: :json
        expect(response).to have_http_status(422)
      end
      it "is success" do
        sign_in @other_user
        put :accept, id: @transfer.id, format: :json
        expect(response).to have_http_status(:success)
      end
      it "rejects when not logged in" do
        put :accept, id: @transfer.id, format: :json
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "PUT to reject" do
    before do
      @user = create :user
      @other_user = create :other_user
      @transfer = build(:transfer) do |transfer|
        transfer.from = @user
        transfer.to = @other_user
      end
      @transfer.save!
    end
    describe "json" do
      it "redirects to root if user is not the receiver of transfer" do
        sign_in @user
        put :reject, id: @transfer.id, format: :json
        expect(response).to have_http_status(422)
      end
      it "is success" do
        sign_in @other_user
        put :reject, id: @transfer.id, format: :json
        expect(response).to have_http_status(:success)
      end
      it "rejects when not logged in" do
        put :reject, id: @transfer.id, format: :json
        expect(response).to have_http_status(401)
      end
    end
  end
end
