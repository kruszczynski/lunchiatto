# Abstraction of model persistence in controllers
module Persistence
  extend ActiveSupport::Concern

  def save_record(model)
    if model.save
      yield(model) if block_given?
      render json: model.decorate
    else
      render json: {errors: model.errors}, status: :unprocessable_entity
    end
  end

  def update_record(model, params)
    if model.update(params)
      yield(model) if block_given?
      render json: model.decorate
    else
      render json: {errors: model.errors}, status: :unprocessable_entity
    end
  end

  def destroy_record(model)
    if model.destroy
      head :no_content
    else
      render json: {errors: model.errors}, status: :unprocessable_entity
    end
  end
end
