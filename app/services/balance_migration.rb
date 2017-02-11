# frozen_string_literal: true
class BalanceMigrationFailed < StandardError; end

class BalanceMigration
  # rubocop:disable Metrics/MethodLength
  # this method reeks of :reek:TooManyStatements, :reek:NestedIterators
  def perform
    Payment.transaction do
      Payment.delete_all
      aggregate.each do |_, user_balances|
        user_balances.reduce(0) do |memo, ub|
          current_cents = ub.balance_cents
          next memo if memo == current_cents
          create_payment(memo, ub)
          current_cents # returns new memo
        end
      end
      fail ActiveRecord::Rollback unless success?
    end
  end

  private

  # this method reeks of :reek:DuplicateMethodCall, :reek:UtilityFunction
  def create_payment(memo, ub)
    amt = memo - ub.balance_cents
    attrs = if amt > 0
              # If amount is greater than zero, it was a regular debt.
              {user: ub.user, payer: ub.payer, balance_cents: amt}
            else
              # Else, it was a repayment (Transfer), so we create a reverse
              # transaction with positive amount.
              # TODO(janek): update type column when STI is ready
              {user: ub.payer, payer: ub.user, balance_cents: -amt}
            end
    Payment.create!(attrs)
  end

  # this method reeks of :reek:UtilityFunction
  def aggregate
    UserBalance.all.order(:created_at).group_by { |ub| [ub.payer_id, ub.user_id] }
  end

  # this method reeks of :reek:DuplicateMethodCall, :reek:TooManyStatements
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

  # this method reeks of :reek:UtilityFunction
  def old_total_balance(user)
    user.total_balance - # my debts to others
      user.total_debt # - others' debt to me, not included in previous model
  end

  # this method reeks of :reek:UtilityFunction
  def new_total_balance(user)
    Balance.new(user).total
  end
end
