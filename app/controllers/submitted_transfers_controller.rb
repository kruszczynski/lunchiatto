class SubmittedTransfersController < ApplicationController
  before_action :authenticate_user!

  def index
    transfers = find_submitted_transfers
    transfers = transfers.to_user(params[:user_id]) if params[:user_id].present?
    render json: transfers
  end

  private

  def find_submitted_transfers
    current_user.submitted_transfers.newest_first.page(params[:page])
  end
end