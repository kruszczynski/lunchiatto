class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :gon_user

  def index
  end
end