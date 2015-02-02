require "spec_helper"


describe TransferMailer, type: :mailer do
  describe "#created_transfer" do
    let(:user) {create :user}
    let(:other_user) {create :other_user}
    let(:transfer) { create :transfer, from: user, to: other_user }
    let(:mail) { TransferMailer.created_transfer(transfer) }

    it "sends an email" do
      expect { mail.deliver_now}.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it "renders the subject" do
      expect(mail.subject).to eql("Bartek Szef has send you a transfer of 15.00 PLN")
    end

    it "renders the receiver email" do
      expect(mail.to).to eql(["krus@test.net"])
    end

    it "renders the sender email" do
      expect(mail.from).to eql(["admin@codequest-manager.herokuapp.com"])
    end
  end

  describe "#accepted_transfer" do
    let(:user) {create :user}
    let(:other_user) {create :other_user}
    let(:transfer) {create :transfer, from: user, to: other_user, status: :accepted}
    let(:mail) { TransferMailer.accepted_transfer(transfer) }

    it "sends an email" do
      expect { mail.deliver_now}.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it "renders the subject" do
      expect(mail.subject).to eql("Kruszcz Puszcz has accepted your transfer of 15.00 PLN")
    end

    it "renders the receiver email" do
      expect(mail.to).to eql(["bartek@test.net"])
    end

    it "renders the sender email" do
      expect(mail.from).to eql(["admin@codequest-manager.herokuapp.com"])
    end
  end

  describe "#rejected_transfer" do
    let(:user) {create :user}
    let(:other_user) {create :other_user}
    let(:transfer) {create :transfer, from: user, to: other_user, status: :rejected}
    let(:mail) { TransferMailer.rejected_transfer(transfer) }

    it "sends an email" do
      expect { mail.deliver_now}.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it "renders the subject" do
      expect(mail.subject).to eql("Kruszcz Puszcz has rejected your transfer of 15.00 PLN")
    end

    it "renders the receiver email" do
      expect(mail.to).to eql(["bartek@test.net"])
    end

    it "renders the sender email" do
      expect(mail.from).to eql(["admin@codequest-manager.herokuapp.com"])
    end
  end

  describe "#pending_transfers" do
    let(:user) {create :user}
    let(:other_user) {create :other_user}
    let(:transfer) {create :transfer, from: user, to: other_user, status: :rejected}
    let(:mail) { TransferMailer.pending_transfers([transfer], other_user) }

    it "sends an email" do
      expect { mail.deliver_now}.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it "renders the subject" do
      expect(mail.subject).to eql("You have pending transfers!")
    end

    it "renders the receiver email" do
      expect(mail.to).to eql(["krus@test.net"])
    end

    it "renders the sender email" do
      expect(mail.from).to eql(["admin@codequest-manager.herokuapp.com"])
    end
  end
end