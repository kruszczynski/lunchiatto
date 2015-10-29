module Api
  class TransfersController < ApplicationController
    before_action :authenticate_user!

    def create
      transfer = Transfer.new transfer_params
      authorize transfer
      transfer.from = current_user
      save_record transfer do |saved_transfer|
        TransferMailer.created_transfer(saved_transfer).deliver_now
      end
    end

    def accept
      transfer = find_transfer
      authorize transfer, :update?
      change_transfer_status(transfer, :accepted)
      render json: transfer
    end

    def reject
      transfer = find_transfer
      authorize transfer, :update?
      change_transfer_status(transfer, :rejected)
      render json: transfer
    end

    private

    def transfer_params
      params.permit(:amount, :to_id)
    end

    def find_transfer
      Transfer.find(params[:id])
    end

    def change_transfer_status(transfer, status)
      ChangeTransferStatus.new(transfer, current_user).perform(status)
    end
  end
end
