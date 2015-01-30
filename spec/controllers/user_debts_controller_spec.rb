require 'spec_helper'

describe UserDebtsController, type: :controller do
  before do
    @user = create :user
    @other_user = create :other_user
    @balance_one = create :user_balance, user: @user, payer: @user, balance: 10
    @balance_two = create :user_balance, user: @user, payer: @other_user, balance: 40
    @balance_three = create :user_balance, user: @user, payer: @other_user, balance: 40
    @balance_four = create :user_balance, user: @user, payer: @user, balance: 40
    @balance_five = create :user_balance, user: @other_user, payer: @other_user, balance: 40
  end
  describe 'GET :index' do
    it 'is success' do
      sign_in @user
      get :index, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to be(1)
    end
    it 'rejects when not logged in' do
      get :index, format: :json
      expect(response).to have_http_status(401)
    end
  end
end
