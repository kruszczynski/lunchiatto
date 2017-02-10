# frozen_string_literal: true
module Api
  class UserBalancesController < ApplicationController
    before_action :authenticate_user!

    def index
      balances = current_user.balances
      render json: balances
    end
  end
end
