# frozen_string_literal: true
class DashboardPolicy < ApplicationPolicy
  def index?
    user.company_id.present?
  end
end
