# frozen_string_literal: true
require 'rails_helper'

RSpec.describe InvitationPolicy do
  let(:invitation) { create :invitation }
  subject { described_class.new(user, invitation) }

  describe '#create?' do
    context 'with admin' do
      let(:user) { create(:user, admin: true) }
      it 'returns true' do
        expect(subject.create?).to be_truthy
      end
    end

    context 'with regular user' do
      let(:user) { create(:user) }
      it 'returns false' do
        expect(subject.create?).to be_falsey
      end
    end
  end
end
