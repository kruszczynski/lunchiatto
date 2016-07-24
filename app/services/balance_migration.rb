# frozen_string_literal: true
class BalanceMigrationFailed < StandardError; end

class BalanceMigration
  def perform
    Payment.transaction do
      Payment.delete_all
      aggregate.each do |key, user_balances|
        user_balances.reduce(0) do |memo, ub|
          next if memo == ub.balance_cents
          create_payment(memo, ub)
          memo = ub.balance_cents
        end
      end
      raise ActiveRecord::Rollback unless success?
    end
  end

  private

  def create_payment(memo, ub)
    amt = memo - ub.balance_cents
    attrs = if amt > 0
      # If amount is greater than zero, it was a regular debt.
      {user: ub.user, payer: ub.payer, balance_cents: amt}
    else
      # Else, it was a repayment (Transfer), so we create a reverse transaction
      # with positive amount.
      # TODO(janek): update type column when STI is ready
      {user: ub.payer, payer: ub.user, balance_cents: -amt}
    end
    Payment.create!(attrs)
  end

  def aggregate
    UserBalance.all.group_by { |ub| [ub.payer_id, ub.user_id] }
  end

  def success?
    User.find_each do |user|
      old_b = old_total_balance(user)
      new_b = new_total_balance(user)
      if new_b != old_b
        puts "User #{user.email} has inconsistent balance information!\n
              UserBalance total: #{old_total_balance(user)}\n
              Payment total:     #{new_total_balance(user)}"
        return false
      end
    end
    true
  end

  def old_total_balance(user)
    user.total_balance - # my debts to others
      user.total_debt # - others' debt to me, not included in previous model
  end

  def new_total_balance(user)
    Balance.new(user).total
  end
end
