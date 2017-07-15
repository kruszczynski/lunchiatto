# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Invitation, type: :model do
  subject { create :invitation }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_most(255) }

  describe 'validate email' do
    let!(:user) { create :user, email: 'test@party.com' }
    subject { build :invitation, email: 'test@party.com' }
    it 'is not valid' do
      expect(subject.valid?).to be_falsey
    end
  end
end
