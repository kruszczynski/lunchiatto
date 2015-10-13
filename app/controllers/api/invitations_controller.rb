module Api
  class InvitationsController < ApplicationController
    before_action :authenticate_user!

    def create
      invitation = current_user.company.invitations.build invitation_params
      authorize invitation
      save_record invitation do |saved_invitation|
        InvitationMailer.created(saved_invitation).deliver_now
      end
    end

    def destroy
      invitation = find_invitation
      authorize invitation
      destroy_record invitation
    end

    private

    def invitation_params
      params.permit(:email).merge(authorized: true)
    end

    def find_invitation
      Invitation.find(params[:id])
    end
  end
end
