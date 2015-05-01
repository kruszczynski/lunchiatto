class TransfersController < ApplicationController
  before_action :authenticate_user!

  def create
    transfer = Transfer.new transfer_params
    authorize transfer
    transfer.from = current_user
    if transfer.save
      TransferMailer.created_transfer(transfer).deliver_now
      render json: transfer
    else
      render json: {errors: transfer.errors}, status: :unprocessable_entity
    end
  end

  def accept
    transfer = find_transfer
    authorize transfer, :update?
    if change_transfer_status(transfer).perform(:accepted)
      render json: transfer
    else
      render json: {errors: transfer.errors}, status: :unprocessable_entity
    end
  end

  def reject
    transfer = find_transfer
    authorize transfer, :update?
    if change_transfer_status(transfer).perform(:rejected)
      render json: transfer
    else
      render json: {errors: transfer.errors}, status: :unprocessable_entity
    end
  end

  private

  def transfer_params
    params.permit(:amount, :to_id)
  end

  def find_transfer
    Transfer.find(params[:id])
  end

  def change_transfer_status(transfer)
    ChangeTransferStatus.new(transfer, current_user)
  end
end