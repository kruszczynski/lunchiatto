class CompanyPolicy < ApplicationPolicy
  def create?
    user.company.blank?
  end
end