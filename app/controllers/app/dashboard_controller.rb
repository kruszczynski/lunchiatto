class App::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_user_has_company
  before_action :gon_user

  layout 'single_page_app'

  def index
    gon.push({
                 users_for_select: User.all_for_select,
                 notice: flash[:notice],
                 alert: flash[:alert]
             })
  end

  private

  def check_if_user_has_company
    redirect_to new_company_url if current_user.company.nil?
  end
end
