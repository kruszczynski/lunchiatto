class DashboardPolicy < ApplicationPolicy
  def index?
    user.company_id.present?
  end
end