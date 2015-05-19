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

  def show
    company = find_company
    authorize company
    render json: company
  end

  def update
    company = find_company
    authorize company
    if company.update(flat_company_params)
      render json: company
    else
      render json: {errors: company.errors}, status: :unprocessable_entity
    end
  end

  private

  def user_not_authorized(exception)
    if params[:action].in? %w(show update)
      super
    else
      redirect_to root_url, notice: "couldn't overwrite an existing company"
    end
  end

  def company_params
    params.require(:company).permit(:name)
  end

  def flat_company_params
    params.permit(:name)
  end

  def company_creator
    CompanyCreator.new(params: company_params, user: current_user)
  end

  def find_company
    Company.find(params[:id])
  end
end
