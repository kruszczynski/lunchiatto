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
    save_record invitation do |invitation|
      UserAccessMailer.create_email(invitation.email).deliver_now
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