class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :substract_from_self,
             :account_number, :admin, :total_balance, :pending_transfers_count

  def total_balance
    object.total_balance.to_s
  end
end