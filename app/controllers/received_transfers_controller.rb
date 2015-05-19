class ReceivedTransfersController < ApplicationController
  before_action :authenticate_user!

  def index
    transfers = find_received_transfers
    transfers = transfers.from_user(params[:user_id]) if params[:user_id].present?
    render json: transfers
  end

  private

  def find_received_transfers
    current_user.received_transfers.newest_first.page(params[:page])
  end
end