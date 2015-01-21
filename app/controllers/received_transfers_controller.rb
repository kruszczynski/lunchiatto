class ReceivedTransfersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_received_transfers

  def index
    render json: @transfers
  end

  private

  def find_received_transfers
    @transfers = current_user.received_transfers.newest_first
  end
end