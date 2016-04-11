# frozen_string_literal: true
require 'spec_helper'

describe UserDecorator do
  let(:company) { instance_double('Company') }
  let(:user) { create(:user).decorate }

  describe '#company_name' do
    it 'returns company name' do
      allow(user).to receive(:company) { company }
      expect(company).to receive(:name) { 'Frying Saucers' }
      expect(user.company_name).to eq('Frying Saucers')
    end
  end
end
