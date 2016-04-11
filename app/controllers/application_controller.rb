# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include Pundit
  include Persistence

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(_resource)
    new_company_url
  end

  def gon_user
    return unless current_user
    gon.push(current_user: UserSerializer.new(current_user),
             destroy_user_session: destroy_user_session_path,
             company_name: current_user.decorate.company_name)
  end

  private

  def user_not_authorized(exception)
    render json: exception.message, status: :unauthorized
  end

  def redirect_to_today
    redirect_to orders_today_path if current_user
  end
end
