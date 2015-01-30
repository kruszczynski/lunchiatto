class ReceivedTransfersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_received_transfers

  def index
    @transfers = @transfers.from_user(params[:user_id]) if params[:user_id].present?
    render json: @transfers
  end

  private

  def find_received_transfers
    @transfers = current_user.received_transfers.newest_first.page(params[:page])
  end
end