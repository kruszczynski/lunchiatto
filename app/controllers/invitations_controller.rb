class InvitationsController < ApplicationController
  def show
    redirect_to_today
    @invitation = find_invitation
    if @invitation.nil?
      return redirect_to root_path, notice: "Invitation already completed please sign in"
    end
  end

  def create
    invitation = Invitation.new invitation_params
    if invitation.save
      UserAccessMailer.create_email(invitation.email).deliver_now
      render json: :no_content
    else
      render json: {errors: invitation.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email)
  end

  def find_invitation
    Invitation.where(id: params[:id]).first
  end
end