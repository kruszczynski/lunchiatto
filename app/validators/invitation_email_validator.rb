class InvitationEmailValidator < ActiveModel::Validator
  def validate(record)
    users = User.where(email: record.email)
    if users.present?
      record.errors[:email] << "is already taken by a user"
    end
  end
end