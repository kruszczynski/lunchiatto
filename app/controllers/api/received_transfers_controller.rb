module Api
  # Received transfers API
  class ReceivedTransfersController < ApplicationController
    before_action :authenticate_user!

    # This method smells of :reek:DuplicateMethodCall
    def index
      transfers = find_received_transfers
      if params[:user_id].present?
        transfers = transfers.from_user(params[:user_id])
      end
      render json: transfers
    end

    private

    def find_received_transfers
      current_user.received_transfers.newest_first.page(params[:page])
    end
  end
end
