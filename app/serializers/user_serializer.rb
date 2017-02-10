# frozen_string_literal: true
class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :subtract_from_self,
             :account_balance,
             :account_number,
             :total_balance,
             :pending_transfers_count,
             :company_admin,
             :company_id

  def total_balance
    object.total_balance.to_s
  end

  def account_balance
    # TODO(janek): could be safely replaced with payer_balance!
    # scope.payer_balance(object).to_s
    scope.debt_to(object).to_s
  end

  def include_account_balance?
    instance_options[:with_balance]
  end
end
