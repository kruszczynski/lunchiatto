# frozen_string_literal: true
require 'rails_helper'

# expects 'policy' let defined
RSpec.shared_context 'allows_policy_action' do |policy, action|
  before { allow_any_instance_of(policy).to receive(action).and_return(true) }
end # shared_examples_for 'allows_policy_action'
