# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'field_with_errors' do
    let(:object) { double }
    let(:yielded_stuff) { sanitize('<input type="text" name="name" />') }
    let(:errors) { {name: ["Can't be blank"]} }
    let(:empty_errors) { {} }
    let(:text_field_proc) { proc { yielded_stuff } }

    it 'renders a label without errors' do
      allow(object).to receive(:errors) { empty_errors }
      allow(empty_errors).to receive(:full_messages_for)
        .with(:name) { [] }
      result = render_field
      expect(result).to match(/^\s*<label>/)
      expect(result).to match(/#{yielded_stuff}/)
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'renders a label with errors' do
      allow(object).to receive(:errors) { errors }
      allow(errors).to receive(:full_messages_for) { ['Name can not be blank'] }
      result = render_field
      expect(errors).to have_received(:full_messages_for).with(:name)
      expect(result).to match(/^\s*<label class="error">/)
      expect(result).to match(/#{yielded_stuff}/)
      expect(result).to match(/<small class="error">Name can not be blank/)
    end

    def render_field
      field_with_errors(object, :name, &text_field_proc)
    end
  end
end
