# frozen_string_literal: true
require 'rails_helper'
require 'active_record'

class InvitationEmailValidatorModel
  include ActiveModel::Validations
  validates_with InvitationEmailValidator
  # This method smells of :reek:Attribute
  attr_accessor :email
end

RSpec.describe InvitationEmailValidator do
  subject { InvitationEmailValidatorModel.new }

  context 'with existing user' do
    let!(:user) { create(:user, email: 'test@party.com') }

    it 'adds errors when email is taken' do
      subject.email = 'test@party.com'
      subject.valid?
      expect(subject.errors.full_messages)
        .to include('Email is already taken by a user')
    end
  end

  it 'does not add errors when email is available' do
    subject.email = 'test@party.com'
    subject.valid?
    expect(subject.errors.full_messages).to eq([])
  end
end
