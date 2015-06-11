require "spec_helper"

describe UserAccessMailer, type: :mailer do
  describe "#create_email" do
    let!(:cqm_admin) { create :user, email: "kruszczyk@gmail.com", admin: true }
    let(:mail) { UserAccessMailer.create_email("guy@wants.in") }

    it "sends an email" do
      expect { mail.deliver_now }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it "renders the subject" do
      expect(mail.subject).to eql("guy@wants.in would like to join CQM")
    end

    it "uses proper receiver email" do
      expect(mail.to).to eql(["kruszczyk@gmail.com"])
    end

    it "uses proper sender email" do
      expect(mail.from).to eql(["admin@codequest-manager.herokuapp.com"])
    end

  end
end