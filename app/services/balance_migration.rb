# frozen_string_literal: true
class BalanceMigration
  def perform
    Payment.transaction do
      Payment.delete_all
      user_balances.reduce(0) do |memo, ub|
        next if memo == ub.balance_cents
        Payment.create!(
          user: ub.user,
          payer: ub.payer,
          amount_cents: memo - ub.balance_cents,
        )
        memo = ub.balance_cents
      end
      raise ActiveRecord::Rollback unless success?
    end
  end

  private

  def user_balances
    UserBalance.all.order(created_at: :asc).group(:payer_id, :user_id)
  end

  def success?
    User.each do |user|
      if old_total_balance(user) != new_total_balance(user)
        puts "User #{user.email} has inconsistent balance information!"
        return false
      end
    end
    true
  end

  def old_total_balance(user)
    user.total_balance
  end

  def new_total_balance(user)
    Balance.new(user).total
  end
end
