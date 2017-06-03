# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CompanySerializer do
  let(:company) { create(:company) }
  let!(:user) { create(:user, company: company) }
  subject { described_class.new company }

  describe '#users' do
    it "sorts'em" do
      expect(subject.users).to eq([user])
    end
  end
end
