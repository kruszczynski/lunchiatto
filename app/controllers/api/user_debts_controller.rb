# frozen_string_literal: true
module Api
  class UserDebtsController < ApplicationController
    before_action :authenticate_user!

    def index
      debts = current_user.debts
      render json: debts
    end
  end
end
