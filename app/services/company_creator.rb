class CompanyCreator
  attr_accessor :user, :company, :params

  def initialize(**context)
    @user, @params = context[:user], context[:params]
    @success = false
  end

  def perform
    @company = Company.new(params)
    company.save
    if company.persisted?
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