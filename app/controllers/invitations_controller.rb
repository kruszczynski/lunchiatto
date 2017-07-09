# frozen_string_literal: true
class InvitationsController < ApplicationController
  def create
    invitation = Invitation.new(invitation_params)
    save_record invitation do |saved_invitation|
      UserAccessMailer.create_email(saved_invitation.email).deliver_later
    end
  end

  def show
    redirect_to_today
    @invitation = find_invitation
    return if @invitation
    redirect_to(root_path, notice: 'Invitation confirmed please sign in')
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email)
  end

  def find_invitation
    Invitation.where(id: params[:id]).first
  end
end
