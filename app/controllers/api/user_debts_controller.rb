# frozen_string_literal: true
module Api
  class UserDebtsController < ApplicationController
    before_action :authenticate_user!

    def index
      # TODO(janek): make into 1 controller
      debts = current_user.debts
      render json: debts
    end
  end
end
