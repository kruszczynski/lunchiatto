# frozen_string_literal: true
class InvitationPolicy < ApplicationPolicy
  def create?
    user.company_id == record.company_id && user.company_admin?
  end
  alias_method :destroy?, :create?
end
