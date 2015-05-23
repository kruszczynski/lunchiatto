require 'spec_helper'

describe Company, type: :model do
  it { should have_many(:users) }
  it { should have_many(:orders) }
  it { should have_many(:invitations) }
  it { should validate_presence_of(:name) }

  let(:user) { create :user, company: subject }
  let(:other_user) { create :other_user, company: subject }
  subject { create :company }

  describe "#users_by_name" do
    it 'returns adequate' do
      expected = [user, other_user]
      expect(subject.users_by_name).to eq(expected)
    end
  end
end
