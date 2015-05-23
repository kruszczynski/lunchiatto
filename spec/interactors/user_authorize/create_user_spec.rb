require "spec_helper"

describe UserAuthorize::CreateUser do
  let(:company) { double("Company") }
  let(:user) { double("User") }
  let(:user_params) { double("user_params") }
  let(:invitation) { double("Invitation") }
  let(:info) { OpenStruct.new(email: "test@codequest.com", name: "Test Smith") }
  let(:omniauth_params) { double("Omniauth::AuthHash", info: info) }
  subject { UserAuthorize::CreateUser.new omniauth_params: omniauth_params, invitation: invitation }

  describe "#call" do
    context "with existing user" do
      it "returns when user is not nil" do
        subject.context.user = user
        expect(User).to_not receive(:new)
        subject.call
      end
    end
    context "with invitation" do
      it "performs" do
        expect(invitation).to receive(:email) { "test@codequest.com" }
        expect(subject).to receive(:user_params) { user_params }
        expect(user).to receive(:save!)
        expect(User).to receive(:new).with(user_params) { user }
        subject.call
        expect(subject.context.user).to eq(user)
      end
      it "fails when invitation's email is different" do
        expect(invitation).to receive(:email) { "sth-else@codequest.com" }
        expect(subject).to_not receive(:user_params) { user_params }
        expect(user).to_not receive(:save!)
        expect(User).to_not receive(:new).with(user_params) { user }
        expect { subject.call }.to raise_error(Interactor::Failure)
      end
    end
  end

  describe "#omniauth_params" do
    it "delegates" do
      expect(subject.omniauth_params).to eq(omniauth_params)
    end
  end

  describe "#invitation" do
    it "delegates" do
      expect(subject.invitation).to eq(invitation)
    end
  end

  describe "#user_params" do
    it "parses" do
      allow(omniauth_params).to receive(:info) { info }
      allow(omniauth_params).to receive(:provider) { "google_oauth2" }
      allow(omniauth_params).to receive(:uid) { "111111111111111111111" }
      allow(invitation).to receive(:company) { company }
      expected = {
          provider: "google_oauth2",
          uid: "111111111111111111111",
          name: "Test Smith",
          email: "test@codequest.com",
          company: company
      }
      expect(subject.user_params).to eq(expected)
    end
  end
end