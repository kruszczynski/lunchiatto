# frozen_string_literal: true
require 'spec_helper'

describe CompanySerializer do
  let(:company) { double('Company') }
  let(:users) { double('Users') }
  subject { described_class.new company }

  describe '#users' do
    it "sorts'em" do
      expect(users).to receive(:by_name) { :sorted_users }
      expect(company).to receive(:users) { users }
      expect(subject.users).to eq(:sorted_users)
    end
  end
end
