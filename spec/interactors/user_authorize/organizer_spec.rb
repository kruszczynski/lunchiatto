require "spec_helper"

describe UserAuthorize::Organizer do
  let(:user) { double("User") }
  subject { UserAuthorize::Organizer.new user: user }

  it "contains FindByUid" do
    expect(UserAuthorize::Organizer.organized).to include(UserAuthorize::FindByUid)
  end

  it "contains FindInvitation" do
    expect(UserAuthorize::Organizer.organized).to include(UserAuthorize::FindInvitation)
  end

  it "contains CreateUser" do
    expect(UserAuthorize::Organizer.organized).to include(UserAuthorize::CreateUser)
  end

  it "contains DeleteInvitation" do
    expect(UserAuthorize::Organizer.organized).to include(UserAuthorize::DeleteInvitation)
  end
end
