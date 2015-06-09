class Api::CompaniesController < ApplicationController
  before_action :authenticate_user!

  def show
    company = find_company
    authorize company
    render json: company
  end

  def update
    company = find_company
    authorize company
    if company.update(company_params)
      render json: company
    else
      render json: {errors: company.errors}, status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.permit(:name)
  end

  def find_company
    Company.find(params[:id])
  end
end
