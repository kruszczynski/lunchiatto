class App::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :gon_user

  layout 'single_page_app'

  def index
    gon.push({
                 users_for_select: User.all_for_select
             })
  end
end