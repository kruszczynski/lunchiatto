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
  let(:user) { instance_double 'User' }

  it 'adds errors when email is taken' do
    subject.email = 'test@party.com'
    expect(User).to receive(:where).with(email: 'test@party.com') { [user] }
    subject.valid?
    expect(subject.errors.full_messages)
      .to include('Email is already taken by a user')
  end

  it 'does not add errors when email is available' do
    subject.email = 'test@party.com'
    expect(User).to receive(:where).with(email: 'test@party.com') { [] }
    subject.valid?
    expect(subject.errors.full_messages).to eq([])
  end
end
