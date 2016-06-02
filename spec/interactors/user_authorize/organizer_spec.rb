# frozen_string_literal: true
require 'spec_helper'

describe UserAuthorize::Organizer do
  let(:user) { instance_double('User') }
  subject { described_class.new user: user }

  it 'contains FindByUid' do
    expect(described_class.organized)
      .to include(UserAuthorize::FindByUid)
  end

  it 'contains FindInvitation' do
    expect(described_class.organized)
      .to include(UserAuthorize::FindInvitation)
  end

  it 'contains CreateUser' do
    expect(described_class.organized)
      .to include(UserAuthorize::CreateUser)
  end

  it 'contains DeleteInvitation' do
    expect(described_class.organized)
      .to include(UserAuthorize::DeleteInvitation)
  end
end
