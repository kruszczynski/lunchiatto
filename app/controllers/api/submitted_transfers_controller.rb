module Api
  class SubmittedTransfersController < ApplicationController
    before_action :authenticate_user!

    def index
      transfers = find_submitted_transfers
      if params[:user_id].present?
        transfers = transfers.to_user(params[:user_id])
      end
      render json: transfers
    end

    private

    def find_submitted_transfers
      current_user.submitted_transfers.newest_first.page(params[:page])
    end
  end
end
