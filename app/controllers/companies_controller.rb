class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_company, only: [:new, :create]

  def new
    @company = Company.new
  end

  def create
    creator = company_creator
    if creator.perform.success?
      redirect_to root_url
    else
      @company = creator.company
      render 'new'
    end
  end

  private

  def company_params
    params.require(:company).permit(:name)
  end

  def check_company
    if current_user.company.present?
      redirect_to root_url, notice: "couldn't overwrite an existing company"
      false
    end
  end

  def company_creator
    CompanyCreator.new(params: company_params, user: current_user)
  end
end