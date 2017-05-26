# frozen_string_literal: true

require 'active_model_serializers'

module Api
  class UserBalancesController < ApplicationController
    before_action :authenticate_user!

    def index
      # TODO(janek): make into 1 controller
      balances = current_user.balances
      render json: ActiveModel::Serializer::CollectionSerializer.new(
        balances, serializer: UserBalanceSerializer
      )
    end
  end
end
