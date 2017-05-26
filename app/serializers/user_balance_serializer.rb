# frozen_string_literal: true
class UserBalanceSerializer < ActiveModel::Serializer
  attributes :balance,
             :created_at,
             :user,
             :user_id

  def balance
    object.balance.to_s
  end

  def user
    object.user.name
  end

  def user_id
    object.user.id
  end

  def created_at
    Time.now # LOL
  end
end
