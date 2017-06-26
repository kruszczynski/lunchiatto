# frozen_string_literal: true
class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :account_balance,
             :account_number,
             :total_balance,
             :pending_transfers_count

  def total_balance
    object.total_balance.to_s
  end

  def account_balance
    scope.payer_balance(object).to_s
  end

  def include_account_balance?
    instance_options[:with_balance]
  end
end
