# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BalanceSerializer do
  let(:usr) { instance_double('User') }
  let(:balance) { Balance::Wrapper.new(usr, '41') }
  subject { described_class.new balance }

  describe '#balance' do
    it 'delegates balance' do
      expect(subject.balance).to eq('41')
    end
  end
end
