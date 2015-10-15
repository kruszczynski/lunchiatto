require 'spec_helper'

describe CompanyPolicy do
  let(:user) { create :user }
  let(:company) { create :company }
  subject { CompanyPolicy.new user, company }

  describe '#create?' do
    it 'returns true when user has no company' do
      expect(subject.create?).to be_truthy
    end
    it 'returns false when user a company' do
      user.company = company
      expect(subject.create?).to be_falsey
    end
  end

  describe '#show?' do
    it 'returns true when user is the company admin' do
      user.company = company
      user.company_admin = true
      expect(subject.show?).to be_truthy
    end
    it "returns false when user isn't the admin" do
      user.company = company
      expect(subject.show?).to be_falsey
    end
    it "returns false when user isn't in the company" do
      expect(subject.show?).to be_falsey
    end
  end

  it 'aliases #update? to #show?' do
    expect(subject.method(:update?) == subject.method(:show?)).to be_truthy
  end
end
