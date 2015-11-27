module Api
  # Invtations API
  class InvitationsController < ApplicationController
    before_action :authenticate_user!

    def create
      invitation = find_or_create_invitation
      authorize invitation
      save_record invitation do |saved_invitation|
        InvitationMailer.created(saved_invitation).deliver_later
      end
    end

    def destroy
      invitation = find_invitation
      authorize invitation
      destroy_record invitation
    end

    private

    def find_or_create_invitation
      Invitation.without_company
        .find_or_initialize_by(email: params[:email]).tap do |invitation|
        invitation.company = current_user.company
        invitation.attributes = invitation_params
      end
    end

    def invitation_params
      params.permit(:email).merge(authorized: true)
    end

    def find_invitation
      Invitation.find(params[:id])
    end
  end
end
