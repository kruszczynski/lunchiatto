class ReceivedTransfersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_received_transfers

  def index
    respond_to do |format|
      format.json { render json: @transfers }
    end
  end

  private

  def find_received_transfers
    @transfers = current_user.received_transfers.newest_first.decorate
  end
end