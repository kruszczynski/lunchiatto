require "spec_helper"

describe UserAuthorize::AddAuthData do
  let(:user) { double("User") }
  let(:info) { OpenStruct.new(email: "test@codequest.com", name: "Test Smith") }
  let(:invalid_info) { OpenStruct.new(email: "test@gmail.com") }
  let(:omniauth_params) { double("Omniauth::AuthHash") }
  let(:user_params) { double("UserParams") }
  subject { UserAuthorize::AddAuthData.new omniauth_params: omniauth_params }

  describe "#call" do

    it "returns when email is inappropriate" do
      expect(omniauth_params).to receive(:info) { invalid_info }
      expect(User).to_not receive(:find_by)
      subject.call
    end

    it "returns when user is not nil" do
      subject.context.user = user
      expect(User).to_not receive(:find_by)
      subject.call
    end

    context "when updating user" do
      before do
        allow(omniauth_params).to receive(:info) { info }
      end
      it "finds a user by email and updates" do
        expect(subject).to receive(:user_params) { user_params }
        expect(user).to receive(:update).with(user_params)
        expect(User).to receive(:find_by).with(email: "test@codequest.com") { user }
        subject.call
      end

      it "sets user to context" do
        allow(subject).to receive(:user_params) { user_params }
        allow(user).to receive(:update).with(user_params)
        allow(User).to receive(:find_by).with(email: "test@codequest.com") { user }
        subject.call
        expect(subject.context.user).to eq(user)
      end

      it "does not do anything when user is not found" do
        allow(subject).to receive(:user_params) { user_params }
        expect(user).to_not receive(:update)
        expect(User).to receive(:find_by).with(email: "test@codequest.com")
        subject.call
        expect(subject.context.user).to be_nil
      end
    end
  end

  describe "#omniauth_params" do
    it "delegates" do
      expect(subject.omniauth_params).to eq(omniauth_params)
    end
  end

  describe "#user_params" do
    it "parses" do
      allow(omniauth_params).to receive(:info) { info }
      allow(omniauth_params).to receive(:provider) { "google_oauth2" }
      allow(omniauth_params).to receive(:uid) { "111111111111111111111" }
      expected = {
          provider: "google_oauth2",
          uid: "111111111111111111111",
          name: "Test Smith"
      }
      expect(subject.user_params).to eq(expected)
    end
  end
end