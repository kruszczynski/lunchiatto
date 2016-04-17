# frozen_string_literal: true
require 'spec_helper'

describe DashboardPolicy do
  let(:user) { create :user }
  let(:company) { create :company }
  subject { described_class.new user, :dashboard }

  describe '#index?' do
    it "returns false when user hasn't got a company" do
      expect(subject.index?).to be_falsey
    end
    it 'returns true otherwise' do
      user.company = company
      expect(subject.index?).to be_truthy
    end
  end
end
