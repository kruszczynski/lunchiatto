# frozen_string_literal: true
require 'rails_helper'

# expects 'policy' let defined
RSpec.shared_context 'allows_policy_action' do |policy, action|
  before { expect_any_instance_of(policy).to receive(action) { true } }
end # shared_examples_for 'policy_allows_action'
