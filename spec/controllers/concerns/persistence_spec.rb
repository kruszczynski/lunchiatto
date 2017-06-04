# frozen_string_literal: true
# rubocop:disable RSpec/DescribedClass, RSpec/SubjectStub
require 'rails_helper'

RSpec.describe Persistence do
  let(:test_class) { Struct.new(:name) { include Persistence } }
  let(:model) { instance_double('User') }
  let(:params) { {name: 'game'} }
  let(:errored_response) do
    {json: {errors: :model_errors}, status: :unprocessable_entity}
  end
  subject { test_class.new('Persistence') }

  describe '#save_record' do
    it 'saves' do
      allow(model).to receive(:save).and_return(true)
      allow(subject).to receive(:render)
      subject.save_record(model)
      expect(model).to have_received(:save)
      expect(subject).to have_received(:render).with(json: model)
    end

    it 'returns errors' do
      allow(model).to receive(:save).and_return(false)
      allow(model).to receive(:errors).and_return(:model_errors)
      allow(subject).to receive(:render)
      subject.save_record(model)
      expect(model).to have_received(:save)
      expect(model).to have_received(:errors)
      expect(subject).to have_received(:render).with(errored_response)
    end

    it 'takes block for success' do
      allow(model).to receive(:save).and_return(true)
      allow(model).to receive(:name)
      allow(subject).to receive(:render)
      subject.save_record(model, &:name)
      expect(model).to have_received(:save)
      expect(model).to have_received(:name)
      expect(subject).to have_received(:render).with(json: model)
    end
  end

  describe '#update_record' do
    it 'updates' do
      allow(model).to receive(:update).and_return(true)
      allow(subject).to receive(:render)
      subject.update_record(model, params)
      expect(model).to have_received(:update).with(params)
      expect(subject).to have_received(:render).with(json: model)
    end

    it 'returns errors' do
      allow(model).to receive(:update).and_return(false)
      allow(model).to receive(:errors).and_return(:model_errors)
      allow(subject).to receive(:render)
      subject.update_record(model, params)
      expect(model).to have_received(:update).with(params)
      expect(model).to have_received(:errors)
      expect(subject).to have_received(:render).with(errored_response)
    end
  end

  describe '#destroy_record' do
    it 'destroys' do
      allow(model).to receive(:destroy).and_return(true)
      allow(subject).to receive(:head)
      subject.destroy_record(model)
      expect(model).to have_received(:destroy)
      expect(subject).to have_received(:head).with(:no_content)
    end

    it 'returns errors' do
      allow(model).to receive(:destroy).and_return(false)
      allow(model).to receive(:errors).and_return(:model_errors)
      allow(subject).to receive(:render)
      subject.destroy_record(model)
      expect(model).to have_received(:destroy)
      expect(model).to have_received(:errors)
      expect(subject).to have_received(:render).with(errored_response)
    end
  end
end
