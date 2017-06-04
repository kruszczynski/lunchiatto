# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Company, type: :model do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:orders) }
  it { is_expected.to have_many(:invitations) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }

  let(:user) { create :user, company: subject }
  let(:other_user) { create :other_user, company: subject }
  subject { create :company }

  describe '#users_by_name' do
    it 'returns adequate' do
      expected = [user, other_user]
      expect(subject.users_by_name).to eq(expected)
    end
  end
end
