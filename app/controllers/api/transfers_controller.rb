module Api
  # Transfers API
  class TransfersController < ApplicationController
    before_action :authenticate_user!

    def index
      transfers = find_transfers
      render json: transfers
    end

    def create
      transfer = Transfer.new transfer_params
      authorize transfer
      transfer.from = current_user
      save_record transfer do |saved_transfer|
        TransferMailer.created_transfer(saved_transfer).deliver_later
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

    def find_transfers
      type = params[:type].to_sym
      fail unless type.in? %i(received submitted)
      # calls received_transfers, submitted_transfers
      transfers = current_user.send("#{type}_transfers")
      # calls filter_submitted_tranfsers, filter_received_tranfsers
      transfers = send("filter_#{type}_tranfsers", transfers, params[:user_id])
      transfers.newest_first.page(params[:page])
    end

    # this method reeks of :reek:UtilityFunction
    def filter_submitted_tranfsers(transfers, user_id)
      return transfers unless user_id.present?
      transfers.to_user(user_id)
    end

    # this method reeks of :reek:UtilityFunction
    def filter_received_tranfsers(transfers, user_id)
      return transfers unless user_id.present?
      transfers.from_user(user_id)
    end

    def change_transfer_status(transfer, status)
      ChangeTransferStatus.new(transfer, current_user).perform(status)
    end
  end
end
