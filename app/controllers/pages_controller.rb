# Public pages
class PagesController < ApplicationController
  def index
    redirect_to_today
  end
end
