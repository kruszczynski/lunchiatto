# frozen_string_literal: true
class Invitation < ActiveRecord::Base
  validates :email, presence: true,
                    uniqueness: true,
                    length: {maximum: 255}
  validates_with InvitationEmailValidator
end
