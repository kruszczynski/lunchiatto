# frozen_string_literal: true
# Company creation requires certain actions on creator and
# this object encapsulates that logic
class CompanyCreator
  attr_reader :user, :company, :params

  def initialize(**context)
    @user = context[:user]
    @params = context[:params]
    @success = false
  end

  def perform
    @company = Company.new(params)
    if company.save
      @user.company = company
      @user.update(company_admin: true)
      @success = true
    end
    self
  end

  def success?
    @success
  end

  def error?
    !success?
  end
end
