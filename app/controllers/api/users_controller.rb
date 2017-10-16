# frozen_string_literal: true
module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
      users = User.all.by_name
      render json: users, with_balance: true
    end

    def show
      user = find_user
      render json: user
    end

    def update
      user = current_user
      update_record user, user_params
    end

    def me
      render json: current_user
    end

    private

    def user_params
      params.permit(:account_number)
    end

    def find_user
      User.find(params[:id])
    end
  end
end
