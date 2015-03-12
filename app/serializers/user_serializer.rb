class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :substract_from_self, :account_balance,
             :account_number, :admin, :total_balance, :pending_transfers_count

  def total_balance
    object.total_balance.to_s
  end

  def account_balance
    current_user.debt_to(object).to_s
  end

  def include_account_balance?
    options[:with_balance]
  end
end