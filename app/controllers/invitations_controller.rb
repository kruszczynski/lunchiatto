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
    if @invitation.nil?
      return redirect_to root_path, notice: "Invitation completed please sign in"
    end
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
    Invitation.where(id: params[:id]).first
  end
end