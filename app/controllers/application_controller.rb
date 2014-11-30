class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    dashboard_index_path
  end

  def gon_user
    return unless current_user
    gon.push({
                 current_user: CurrentUserSerializer.new(current_user),
                 destroy_user_session: destroy_user_session_path
             })
  end
end
