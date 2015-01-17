class PagesController < ApplicationController
  before_filter :redirect_to_dashboard, only: :index
  def index

  end

  def redirect_to_dashboard
    redirect_to app_dashboard_path if current_user
  end
end
