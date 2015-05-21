require "spec_helper"

describe UserAuthorize::Organizer do
  let(:user) { double("User") }
  subject { UserAuthorize::Organizer.new user: user }

  it "contains FindByUid" do
    expect(UserAuthorize::Organizer.organized).to include(UserAuthorize::FindByUid)
  end

  it "contains AddAuthData" do
    expect(UserAuthorize::Organizer.organized).to include(UserAuthorize::AddAuthData)
  end
end
