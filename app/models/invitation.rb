class Invitation < ActiveRecord::Base
  belongs_to :company
  validates :email, presence: true,
                    uniqueness: true,
                    length: {maximum: 255}
  validates_with InvitationEmailValidator

  scope :without_company, -> { where(company_id: nil) }
end
