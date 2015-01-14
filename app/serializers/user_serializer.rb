class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :substract_from_self, :account_number, :user_balance

  def user_balance
  	current_user.user_balances.newest_for(object.id).try(:balance).to_s || '0.00'
  end
end