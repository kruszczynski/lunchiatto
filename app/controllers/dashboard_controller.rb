# frozen_string_literal: true
class DashboardController < ApplicationController
  def index
    return unless current_user
    gon_user
    gon.push(users_for_select: users_for_select,
             notice: flash[:notice],
             alert: flash[:alert])
  end

  private

  def user_not_authorized
    redirect_to root_url
  end

  def users_for_select
    ActiveModel::Serializer::CollectionSerializer.new(
      User.all.by_name,
      each_serializer: UserForSelectSerializer,
      scope: current_user,
    )
  end
end
