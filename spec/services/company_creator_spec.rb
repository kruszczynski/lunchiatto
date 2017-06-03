# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CompanyCreator do
  subject { described_class.new(params: company_params, user: user) }

  let(:user) { create :user }
  let(:company_params) { {name: 'Pink Boogers LTD'} }
  let(:empty_company_params) { {name: ''} }

  describe '#intialize' do
    it 'assigns variables' do
      expect(subject.user).to eq(user)
      expect(subject.params).to eq(company_params)
    end
  end

  describe '#success?' do
    it 'is false by default' do
      expect_success false
    end

    it 'returns true after a successful perform' do
      subject.perform
      expect_success true
    end

    context 'with failure' do
      subject { described_class.new(params: empty_company_params, user: user) }
      it 'returns false after a failure' do
        subject.perform
        expect_success false
      end
    end

    def expect_success(val)
      expect(subject.success?).to eq val
    end
  end

  # rubocop:disable RSpec/SubjectStub
  describe '#error?' do
    it 'is the opposite of success' do
      allow(subject).to receive(:success?).and_return(true, false)
      2.times do |i|
        expect(subject.error?).to eq i == 1
      end
    end
  end

  describe '#perform' do
    it 'returns self' do
      expect(subject.perform).to eq subject
    end

    context 'With valid data' do
      it 'creates a company' do
        expect { subject.perform }.to change(Company, :count)
      end
      it 'assigns user fields' do
        subject.perform
        expect(user.company).to eq(subject.company)
        expect(user.company_admin).to be_truthy
      end
    end
    context 'With an existing name' do
      before do
        create :company, name: 'Pink Boogers LTD'
      end
      it "doesn't create a company" do
        expect { subject.perform }.not_to change(Company, :count)
      end
      it "doesn't assign user fields" do
        subject.perform
        expect(user.company).to be_nil
        expect(user.company_admin).to be_falsey
      end
    end

    context 'With an empty name' do
      subject { described_class.new(params: empty_company_params, user: user) }
      it "doesn't create a company" do
        expect { subject.perform }.not_to change(Company, :count)
      end
      it "doesn't assign user fields" do
        subject.perform
        expect(user.company).to be_nil
        expect(user.company_admin).to be_falsey
      end
    end
  end
end
