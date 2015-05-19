require "spec_helper"

describe "status_email:send" do
  let(:company) { create :company }
  let(:user) { create :user, company: company }
  let!(:order1) { create :order, user: user, company: company }
  let!(:order2) { create :order, user: user, company: company, from: "diff", status: Order.statuses[:delivered] }
  let!(:order3) { create :order, user: user, company: company, from: "diff2", status: Order.statuses[:ordered] }
  include_context 'rake'

  it "sends email" do
    expect {
      subject.invoke
    }.to change(ActionMailer::Base.deliveries, :count).by(2)
  end


end

