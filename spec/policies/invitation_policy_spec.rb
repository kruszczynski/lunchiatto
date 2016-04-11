# frozen_string_literal: true
require 'spec_helper'

describe InvitationPolicy do
  let(:company) { create :company }
  let(:other_company) { create :other_company }
  let(:user) { create :user, company: company, company_admin: true }
  let(:other_user) { create :other_user, company: company }
  let(:invitation) { create :invitation, company: company }
  let(:other_invitation) { create :invitation, company: other_company }
  subject { InvitationPolicy.new user, invitation }

  describe '#create?' do
    context 'with company admin' do
      it 'returns true' do
        expect(subject.create?).to be_truthy
      end
    end

    context 'with policy from a different company' do
      let(:policy) { InvitationPolicy.new user, other_invitation }
      it 'returns false' do
        expect(policy.create?).to be_falsey
      end
    end

    context 'with ordinary user' do
      let(:policy) { InvitationPolicy.new other_user, invitation }
      it 'returns false' do
        expect(policy.create?).to be_falsey
      end
    end
  end

  it 'aliases #destroy? to #create?' do
    expect(subject.method(:destroy?) == subject.method(:create?)).to be_truthy
  end
end
