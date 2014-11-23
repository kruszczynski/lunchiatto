require 'spec_helper'

describe SubmittedTransfersController, type: :controller do
  before do
    @user = create :user
    @other_user = create :other_user
    @transfer = build(:transfer) do |transfer|
      transfer.from = @user
      transfer.to = @other_user
    end
    @transfer.save!
    @other_transfer = build(:transfer) do |transfer|
      transfer.from = @user
      transfer.to = @other_user
    end
    @other_transfer.save!
  end
  describe 'GET :index' do
    it 'is success' do
      sign_in @user
      get :index, format: :json
      expect(response).to have_http_status(:success)
    end
    it 'rejects when not logged in' do
      get :index, format: :json
      expect(response).to have_http_status(401)
    end
  end
end
