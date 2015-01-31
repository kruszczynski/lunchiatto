require "spec_helper"

describe ChangeTransferStatus do
  let(:user) {create :user}
  let(:other_user) {create :other_user}
  let(:transfer) {create :transfer, from: user, to: user}
  let(:accepted_transfer) {create :transfer, from: user, to: other_user, status: :accepted}

  let(:service) {ChangeTransferStatus.new transfer, user}
  let(:other_user_service) {ChangeTransferStatus.new transfer, other_user}
  let(:accepted_transfer_service) {ChangeTransferStatus.new accepted_transfer, other_user}

  it "initializes" do
    expect(service.transfer).to be(transfer)
    expect(service.user).to be(user)
  end

  describe "#change_status" do
    describe "accepts" do
      it "sends acception email" do
        expect{service.change_status(:accepted)}.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
      it "changes status" do
        service.change_status(:accepted)
        expect(transfer.status).to eq("accepted")
      end
      it "returns true" do
        expect(service.change_status(:accepted))
      end
    end
    describe "rejects" do
      it "sends rejection email" do
        expect{service.change_status(:rejected)}.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
      it "changes status" do
        service.change_status(:rejected)
        expect(transfer.status).to eq("rejected")
      end
      it "returns true" do
        expect(service.change_status(:rejected))
      end
    end
    describe "not pending" do
      it "returns false" do
        expect(accepted_transfer_service.change_status(:accepted)).to be_falsey
      end
      it "doesn't send email" do
        expect{accepted_transfer_service.change_status(:accepted)}.to_not change(ActionMailer::Base.deliveries, :count)
      end
    end
    describe "not to current_user" do
      it "returns false" do
        expect(other_user_service.change_status(:accepted)).to be_falsey
      end
      it "doesn't send email" do
        expect{other_user_service.change_status(:accepted)}.to_not change(ActionMailer::Base.deliveries, :count)
      end
      it "doesn't change status" do
        other_user_service.change_status(:accepted)
        expect(transfer.status).to eq("pending")
      end
    end
  end
end