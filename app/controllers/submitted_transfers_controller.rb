class SubmittedTransfersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_submitted_transfers

  def index
    render json: @transfers
  end

  private

  def find_submitted_transfers
    @transfers = current_user.submitted_transfers.newest_first.page(params[:page])
  end
end