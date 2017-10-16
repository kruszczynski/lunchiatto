# frozen_string_literal: true
class DashboardController < ApplicationController
  def index; end

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
