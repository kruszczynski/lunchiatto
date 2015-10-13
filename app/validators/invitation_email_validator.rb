class InvitationEmailValidator < ActiveModel::Validator
  def validate(record)
    users = User.where(email: record.email)
    record.errors[:email] << 'is already taken by a user' if users.present?
  end
end
