# frozen_string_literal: true
# rubocop:disable RSpec/DescribeClass
require 'rails_helper'

RSpec.describe 'load_seeds' do
  let(:valid_email) { 'jan@gmail.com' }
  include_context 'rake'

  it 'raises an error when user is not found' do
    expect { subject.invoke('jan@jan.pl') }.to raise_error(RuntimeError)
  end

  it 'raises an error with no parameters' do
    expect { subject.invoke }.to raise_error(RuntimeError)
  end
end
