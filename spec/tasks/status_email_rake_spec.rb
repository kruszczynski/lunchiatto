require 'spec_helper'

describe 'status_email:send' do
  let(:company) { create :company }
  let(:user) { create :user, company: company }
  let!(:order1) { create :order, user: user, company: company }
  let!(:order2) do
    create :order, user: user, company: company, from: 'diff',
                   status: Order.statuses[:delivered]
  end
  let!(:order3) do
    create :order, user: user, company: company, from: 'diff2',
                   status: Order.statuses[:ordered]
  end

  include_context 'rake'

  it 'sends email' do
    expect do
      subject.invoke
    end.to change(ActionMailer::Base.deliveries, :count).by(2)
  end
end
