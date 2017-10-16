# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include Pundit
  include Persistence

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(_resource)
    orders_today_path
  end

  private

  def user_not_authorized(exception)
    render json: exception.message, status: :unauthorized
  end
end
