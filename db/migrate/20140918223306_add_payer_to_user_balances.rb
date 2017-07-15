class AddPayerToUserBalances < ActiveRecord::Migration[4.2]
  def change
    add_reference :user_balances, :payer, index: true
  end
end
