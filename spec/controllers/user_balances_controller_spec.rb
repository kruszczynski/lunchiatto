require 'spec_helper'

describe UserBalancesController, type: :controller do
  before do
    @user = create :user
    @other_user = create :other_user
    @balance_one = build :user_balance do |b|
      b.user = @user
      b.payer = @user
      b.balance = 10
      b.save!
    end
    @balance_two = build :user_balance do |b|
      b.user = @user
      b.payer = @other_user
      b.balance = 40
      b.save!
    end
    @balance_three = build :user_balance do |b|
      b.user = @user
      b.payer = @other_user
      b.balance = 40
      b.save!
    end
    @balance_four = build :user_balance do |b|
      b.user = @user
      b.payer = @user
      b.balance = 40
      b.save!
    end
    @balance_five = build :user_balance do |b|
      b.user = @other_user
      b.payer = @other_user
      b.balance = 40
      b.save!
    end
  end
  describe 'GET :index' do
    it 'is success' do
      sign_in @user
      get :index, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to be(2)
    end
    it 'rejects when not logged in' do
      get :index, format: :json
      expect(response).to have_http_status(401)
    end
  end
end
