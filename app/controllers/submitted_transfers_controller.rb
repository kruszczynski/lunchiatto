class SubmittedTransfersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_submitted_transfers

  def index
    respond_to do |format|
      format.json { render json: @transfers }
    end
  end

  private

  def find_submitted_transfers
    @transfers = current_user.submitted_transfers.newest_first.decorate
  end
end