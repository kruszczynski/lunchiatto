# Validates that invitation's emails
# are not registered already in the app
class InvitationEmailValidator < ActiveModel::Validator
  # This method smells of :reek:UtilityFunction
  def validate(record)
    users = User.where(email: record.email)
    record.errors[:email] << 'is already taken by a user' if users.present?
  end
end
