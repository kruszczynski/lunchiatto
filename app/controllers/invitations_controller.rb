class InvitationsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def create
    invitation = current_user.company.invitations.build invitation_params
    authorize invitation
    if invitation.save
      InvitationMailer.created(invitation).deliver_now
      render json: invitation
    else
      render json: {errors: invitation.errors}, status: :unprocessable_entity
    end
  end

  def show
    redirect_to_today
    @invitation = find_invitation
  end

  def destroy
    invitation = find_invitation
    authorize invitation
    if invitation.delete
      render json: {status: 'success'}
    else
      render json: {status: "failed"}
    end
  end

  private

  def invitation_params
    params.permit(:email)
  end

  def find_invitation
    Invitation.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, notice: "The invitation is not valid anymore"
  end
end