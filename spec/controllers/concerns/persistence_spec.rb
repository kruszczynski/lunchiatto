require 'spec_helper'

describe Persistence do
  let(:test_class) { Struct.new(:name) { include Persistence } }
  let(:persistence) { test_class.new('Persistence') }
  let(:model) { double('Model') }

  describe '#save_record' do
    it 'saves' do
      expect(model).to receive(:save).and_return(true)
      expect(model).to receive(:decorate).and_return(:decorated_model)
      expect(persistence).to receive(:render).with(json: :decorated_model)
      persistence.save_record(model)
    end

    it 'returns errors' do
      expect(model).to receive(:save).and_return(false)
      expect(model).to receive(:errors).and_return(:model_errors)
      expect(persistence).to receive(:render)
        .with(json: {errors: :model_errors}, status: :unprocessable_entity)
      persistence.save_record(model)
    end

    it 'takes block for success' do
      expect(model).to receive(:save).and_return(true)
      expect(model).to receive(:decorate).and_return(:decorated_model)
      expect(persistence).to receive(:render).with(json: :decorated_model)
      expect(model).to receive(:block_call)
      persistence.save_record(model, &:block_call)
    end
  end

  describe '#update_record' do
    let(:params) { {name: 'game'} }
    it 'updates' do
      expect(model).to receive(:update).with(params).and_return(true)
      expect(model).to receive(:decorate).and_return(:decorated_model)
      expect(persistence).to receive(:render).with(json: :decorated_model)
      persistence.update_record(model, params)
    end

    it 'returns errors' do
      expect(model).to receive(:update).with(params).and_return(false)
      expect(model).to receive(:errors).and_return(:model_errors)
      expect(persistence).to receive(:render)
        .with(json: {errors: :model_errors}, status: :unprocessable_entity)
      persistence.update_record(model, params)
    end
  end

  describe '#destroy_record' do
    it 'destroys' do
      expect(model).to receive(:destroy).and_return(true)
      expect(persistence).to receive(:render).with(json: {status: 'success'})
      persistence.destroy_record(model)
    end

    it 'returns errors' do
      expect(model).to receive(:destroy).and_return(false)
      expect(model).to receive(:errors).and_return(:model_errors)
      expect(persistence).to receive(:render)
        .with(json: {errors: :model_errors}, status: :unprocessable_entity)
      persistence.destroy_record(model)
    end
  end
end
