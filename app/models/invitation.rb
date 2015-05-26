class Invitation < ActiveRecord::Base
  belongs_to :company
  validates :company, presence: true
  validates :email, presence: true, uniqueness: true
  validates_with InvitationEmailValidator
end