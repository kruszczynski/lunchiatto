# frozen_string_literal: true
class OrderPolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    record.in_progress? || record.ordered? && record_belongs_to_user?
  end

  def destroy?
    record.in_progress? && record_belongs_to_user?
  end

  def change_status?
    !record.delivered? && record_belongs_to_user?
  end
end
