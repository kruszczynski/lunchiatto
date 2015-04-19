class PagesController < ApplicationController
  before_filter :redirect_to_today, only: :index

  private

  def redirect_to_today
    redirect_to app_orders_today_path if current_user
  end
end
