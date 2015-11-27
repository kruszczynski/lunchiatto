# Non-api controller for company creation
class CompaniesController < ApplicationController
  before_action :authenticate_user!

  def new
    authorize :company, :create?
    @company = Company.new
  end

  def create
    authorize :company
    creator = company_creator
    if creator.perform.success?
      redirect_to root_url
    else
      @company = creator.company
      render 'new'
    end
  end

  private

  def user_not_authorized(_exception)
    redirect_to root_url, notice: "couldn't overwrite an existing company"
  end

  def company_params
    params.require(:company).permit(:name)
  end

  def company_creator
    CompanyCreator.new(params: company_params, user: current_user)
  end
end
