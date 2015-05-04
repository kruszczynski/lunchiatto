require "spec_helper"

describe CompanyPolicy do
  let(:user) { create :user }
  let(:company) { create :company }
  subject { CompanyPolicy.new user, company }

  describe "#create?" do
    it "returns true when user has no company" do
      expect(subject.create?).to be_truthy
    end
    it "returns false when user a company" do
      user.company = company
      expect(subject.create?).to be_falsey
    end
  end
end