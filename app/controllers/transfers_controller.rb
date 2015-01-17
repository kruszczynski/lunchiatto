class TransfersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_transfer, except: [:create]

  def create
    @transfer = Transfer.new transfer_params
    @transfer.from = current_user
    if @transfer.save
      respond_to do |format|
        format.json { render json: @transfer }
      end
    else
      respond_to do |format|
        format.json { render json: {errors: @transfer.errors}, status: :unprocessable_entity }
      end
    end
  end

  def accept
    if current_user == @transfer.to && @transfer.pending?
      @transfer.mark_as_accepted!
      respond_to do |format|
        format.json { render json: @transfer}
      end
    else
      respond_to do |format|
        format.json { render json: {errors: @transfer.errors}, status: :unprocessable_entity}
      end
    end
  end

  def reject
    if current_user == @transfer.to && @transfer.pending?
      @transfer.rejected!
      respond_to do |format|
        format.json { render json: @transfer }
      end
    else
      respond_to do |format|
        format.json { render json: {errors: @transfer.errors}, status: :unprocessable_entity }
      end
    end
  end

  private

  def transfer_params
    params.permit(:amount, :to_id)
  end

  def find_transfer
    @transfer = Transfer.find(params[:id])
  end
end