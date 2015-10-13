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
      render json: model.decorate
    else
      render json: {errors: model.errors}, status: :unprocessable_entity
    end
  end

  def destroy_record(model)
    if model.destroy
      render json: {status: 'success'}
    else
      render json: {errors: model.errors}, status: :unprocessable_entity
    end
  end
end
