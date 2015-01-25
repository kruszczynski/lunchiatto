require "spec_helper"


describe TransferMailer, type: :mailer do
  describe "#created_transfer" do
    let(:user) {create :user}
    let(:other_user) {create :other_user}
    let(:transfer) do
      transfer = build :transfer do |transfer|
        transfer.from = user
        transfer.to = other_user
      end
      transfer.save!
      transfer
    end
    let(:mail) { TransferMailer.created_transfer(transfer) }

    it "sends an email" do
      expect { mail.deliver_now}.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "renders the subject" do
      expect(mail.subject).to eql("Bartek Szef has send you a transfer of 15.00 PLN")
    end

    it "renders the receiver email" do
      expect(mail.to).to eql(["krus@test.net"])
    end

    it "renders the sender email" do
      expect(mail.from).to eql(["noreply@codequest-manager.herokuapp.com"])
    end

  end
end