# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Invitation, type: :model do
  let(:company) { create :company }
  subject { create :invitation, company: company }

  it { is_expected.to belong_to(:company) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_most(255) }
  it { is_expected.to have_db_column(:authorized).with_options(default: false) }

  describe 'validate email' do
    let!(:user) { create :user, email: 'test@party.com' }
    subject { build :invitation, company: company, email: 'test@party.com' }
    it 'is not valid' do
      expect(subject.valid?).to be_falsey
    end
  end
end
