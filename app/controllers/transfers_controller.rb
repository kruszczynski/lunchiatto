class TransfersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_transfer, except: [:create]

  def create
    @transfer = Transfer.new transfer_params
    @transfer.from = current_user
    if @transfer.save
      TransferMailer.created_transfer(@transfer).deliver_now
      render json: @transfer
    else
      render json: {errors: @transfer.errors}, status: :unprocessable_entity
    end
  end

  def accept
    if change_transfer_status.perform(:accepted)
      render json: @transfer
    else
      render json: {errors: @transfer.errors}, status: :unprocessable_entity
    end
  end

  def reject
    if change_transfer_status.perform(:rejected)
      render json: @transfer
    else
      render json: {errors: @transfer.errors}, status: :unprocessable_entity
    end
  end

  private

  def transfer_params
    params.permit(:amount, :to_id)
  end

  def find_transfer
    @transfer = Transfer.find(params[:id])
  end

  def change_transfer_status
    ChangeTransferStatus.new(@transfer, current_user)
  end
end