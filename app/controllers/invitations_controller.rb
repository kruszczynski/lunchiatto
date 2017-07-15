# frozen_string_literal: true
class InvitationsController < ApplicationController
  def show
    redirect_to_today
    @invitation = find_invitation
    return if @invitation
    redirect_to(root_path, notice: 'Invitation confirmed please sign in')
  end

  private

  def find_invitation
    Invitation.where(id: params[:id]).first
  end
end
