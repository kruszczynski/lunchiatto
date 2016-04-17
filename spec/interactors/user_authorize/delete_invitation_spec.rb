# frozen_string_literal: true
require 'spec_helper'

describe UserAuthorize::DeleteInvitation do
  let(:invitation) { double('Invitation') }
  subject { described_class.new }

  describe '#call' do
    it 'deletes the invitation' do
      subject.context.invitation = invitation
      expect(invitation).to receive(:delete)
      subject.call
    end

    it 'works when invitation is nil' do
      # no expectation here but this will fail if invitation is nil
      subject.call
    end
  end
end
