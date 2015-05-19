require 'spec_helper'

describe ApplicationHelper, type: :helper do
  describe 'field_with_errors' do
    let(:object) { double(errors: {}) }
    let(:yielded_stuff) { sanitize('<input type="text" name="name" />') }
    let(:errors) { {name: ["Can't be blank"]} }
    let(:text_field_proc) { Proc.new { yielded_stuff } }

    it 'renders a label without errors' do
      result = render_field
      expect(result).to match /^\s*<label>/
      expect(result).to match /#{yielded_stuff}/
    end

    it 'renders a label with errors' do
      allow(object).to receive(:errors) { errors }
      expect(errors).to receive(:full_messages_for).with(:name) {["Name can not be blank"]}
      result = render_field
      expect(result).to match /^\s*<label class="error">/
      expect(result).to match /#{yielded_stuff}/
      expect(result).to match /<small class="error">Name can not be blank/
    end

    def render_field
      field_with_errors(object, :name, &text_field_proc)
    end
  end
end