class UserBalanceSerializer < ActiveModel::Serializer
  attributes :id, :balance, :created_at, :user, :payer

  def balance
    object.balance.to_s
  end

  def created_at
    object.created_at
  end

  def user
    object.user.name
  end

  def payer
    object.payer.name
  end
end