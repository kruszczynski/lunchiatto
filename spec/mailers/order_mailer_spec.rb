require "spec_helper"


describe OrderMailer, type: :mailer do
  describe "#status_email" do
    let(:company) { create :company }
    let(:user) { create :user, company: company }
    let(:order) { create :order, user: user, from: 'The food place', company: company }
    let(:mail) { OrderMailer.status_email(order) }

    it "sends an email" do
      expect { mail.deliver_now}.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it "renders the subject" do
      expect(mail.subject).to eql("Bartek Szef, mark today's order as delivered")
    end

    it "renders the receiver email" do
      expect(mail.to).to eql(["bartek@test.net"])
    end

    it "renders the sender email" do
      expect(mail.from).to eql(["admin@codequest-manager.herokuapp.com"])
    end
  end
end
