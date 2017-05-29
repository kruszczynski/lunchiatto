# frozen_string_literal: true

require 'active_model_serializers'

module Api
  class BalancesController < ApplicationController
    before_action :authenticate_user!

    def index
      balances = current_user.balances
      render json: ActiveModel::Serializer::CollectionSerializer.new(
        balances, serializer: BalanceSerializer
      )
    end
  end
end
