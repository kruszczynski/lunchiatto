require "spec_helper"

describe Invitation, type: :model do
  let(:company) { create :company }
  subject { create :invitation, company: company }

  it { should belong_to(:company) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_length_of(:email).is_at_most(255) }

  describe "validate email" do
    let!(:user) { create :user, email: "test@party.com" }
    subject { build :invitation, company: company, email: "test@party.com" }
    it "is not valid" do
      expect(subject.valid?).to be_falsey
    end
  end
end