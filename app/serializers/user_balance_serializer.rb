class UserBalanceSerializer < ActiveModel::Serializer
  attributes :id, :balance
  has_one :user
  has_one :payer

  def balance
    object.balance.to_s
  end
end