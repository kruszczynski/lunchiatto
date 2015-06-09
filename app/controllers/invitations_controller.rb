class InvitationsController < ApplicationController
  def show
    redirect_to_today
    @invitation = find_invitation
    if @invitation.nil?
      return redirect_to root_path, notice: "Invitation completed please sign in"
    end
  end

  private

  def find_invitation
    Invitation.where(id: params[:id]).first
  end
end