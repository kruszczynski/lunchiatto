# frozen_string_literal: true
module Api
  class CompaniesController < ApplicationController
    before_action :authenticate_user!

    def show
      company = find_company
      authorize company
      render json: company
    end

    def update
      company = find_company
      authorize company
      update_record company, company_params
    end

    private

    def company_params
      params.permit(:name)
    end

    def find_company
      Company.find(params[:id])
    end
  end
end
