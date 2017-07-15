# frozen_string_literal: true
module Api
  class InvitationsController < ApplicationController
    before_action :authenticate_user!

    def create
      invitation = find_or_create_invitation
      authorize invitation
      save_record invitation do |saved_invitation|
        InvitationMailer.created(saved_invitation).deliver_later
      end
    end

    def index
      authorize Invitation
      render json: Invitation.all
    end

    def destroy
      invitation = find_invitation
      authorize invitation
      destroy_record invitation
    end

    private

    def find_or_create_invitation
      Invitation.new(invitation_params)
    end

    def invitation_params
      params.permit(:email)
    end

    def find_invitation
      Invitation.find(params[:id])
    end
  end
end
