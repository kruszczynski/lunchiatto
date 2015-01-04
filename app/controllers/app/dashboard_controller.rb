class App::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :gon_user

  layout 'single_page_app'

  def index
  end
end