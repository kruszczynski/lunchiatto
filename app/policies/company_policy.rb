class CompanyPolicy < ApplicationPolicy
  def create?
    user.company.blank?
  end

  def show?
    user.company == record && user.company_admin?
  end
  alias_method :update?, :show?
end
